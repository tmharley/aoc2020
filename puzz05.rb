# frozen_string_literal: true

TEST_INPUT = %w[BFFFBBFRRR FFFBBBFRRR BBFFBBFRLL].freeze
NUM_ROWS = 128
NUM_COLS = 8

def import_from_file(filename)
  file = File.open(filename)
  file.readlines.map(&:chomp)
end

# range of possible seats is from range_start to (range_end - 1), inclusive
def divide(range_start, range_end, remaining)
  if %w[B R].include?(remaining[0])
    range_start = (range_start + range_end) / 2
  elsif %w[F L].include?(remaining[0])
    range_end = (range_start + range_end) / 2
  end

  if range_start == range_end - 1
    range_start
  else
    divide(range_start, range_end, remaining[1...remaining.length])
  end
end

def seat_id(pass)
  row = divide(0, NUM_ROWS, pass[0..6])
  col = divide(0, NUM_COLS, pass[7..9])
  row * 8 + col
end

def part_one(input)
  input.map { |pass| seat_id(pass) }.max
end

def part_two(input)
  index = 1
  missing_seats = (1...(NUM_ROWS * NUM_COLS)).to_a
  taken_seats = input.map { |pass| seat_id(pass) }
  missing_seats -= taken_seats

  # remove the nonexistent seats at the front
  while missing_seats.first == index
    missing_seats.shift
    index += 1
  end

  missing_seats.first
end

p 'Test outputs (should be 567, 119, 820):'
TEST_INPUT.each do |test|
  p seat_id(test)
end

input = import_from_file('puzz05_input.txt')

p "Part 1: #{part_one(input)}"
p "Part 2: #{part_two(input)}"
