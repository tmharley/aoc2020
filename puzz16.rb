# frozen_string_literal: true

RANGE = /(\d+)-(\d+)/.freeze

def find_all_ranges(input)
  all_ranges = {}
  input.split("\n").each do |line|
    break if line == ''

    field_name, definition = line.split(':')
    tokens = definition.split(' ')
    ranges = []
    tokens.each do |token|
      if (md = token.match(RANGE))
        ranges << (md[1].to_i..md[2].to_i)
      end
    end
    all_ranges[field_name] = ranges
  end
  all_ranges
end

def validate_nearby_tickets(input)
  errors = 0
  ranges = find_all_ranges(input[0])
  tickets = input[2].split("\n")
  tickets.each do |ticket|
    ticket.split(',').each { |field| errors += check_field(field, ranges) }
  end
  errors
end

# @return the remaining valid tickets
def expunge_invalid_tickets(ticket_list, valid_ranges)
  valid_tickets = []
  tickets = ticket_list.split("\n")
  tickets.each do |ticket|
    bad_field = ticket.include?(':') # discard header line
    ticket.split(',').each do |field|
      unless check_field(field, valid_ranges).zero?
        bad_field = true
        break
      end
    end
    valid_tickets << ticket unless bad_field
  end
  valid_tickets
end

def check_field(field_to_check, valid_ranges)
  value = field_to_check.to_i
  valid_ranges.each_value do |field|
    field.each { |range| return 0 if range.include?(value) }
  end
  value
end

def valid_for_field?(value, ranges)
  ranges.each { |range| return true if range.include?(value) }
  false
end

def my_ticket(input)
  input.split("\n")[1].split(',').map(&:to_i)
end

def possible_orders(input)
  fields = find_all_ranges(input[0])
  nearby_tickets = expunge_invalid_tickets(input[2], fields)
  possible_orders = []
  fields.length.times do |i|
    possibilities = fields.keys
    nearby_tickets.each do |ticket|
      value = ticket.split(',')[i].to_i
      possibilities.each do |field|
        valid = valid_for_field?(value, fields[field])
        possibilities -= [field] unless valid
      end
    end
    possible_orders << possibilities
  end
  possible_orders
end

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

def part_one(input)
  input_parts = input.split("\n\n")
  validate_nearby_tickets(input_parts)
end

def part_two(input)
  input_parts = input.split("\n\n")
  order = possible_orders(input_parts)
  uniques = []
  loop do
    found_uniques = order.map { |po| po[0] if po.length == 1 }.compact!
    break if found_uniques.nil?

    uniques += found_uniques
    uniques.each do |u|
      order.map! { |po2| po2.length == 1 ? po2 : po2 - [u] }
      uniques -= [u]
    end
  end
  my_ticket = my_ticket(input_parts[1])
  order.flatten!.map.with_index do |field, index|
    field.start_with?('departure') ? my_ticket[index] : 1
  end.reduce(:*)
end

TEST_INPUT = import_from_file('puzz16_test.txt')
TEST_INPUT_2 = import_from_file('puzz16_test2.txt')
REAL_INPUT = import_from_file('puzz16_input.txt')

p part_one(TEST_INPUT) # should return 71
p part_one(REAL_INPUT)

p part_two(TEST_INPUT_2)
p part_two(REAL_INPUT)
