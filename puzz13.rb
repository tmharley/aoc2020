# frozen_string_literal: true

TEST_INPUT = <<~INPUT
  939
  7,13,x,x,59,x,31,19
INPUT

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

def part_one(input)
  timestamp, bus_list = input.split("\n")
  timestamp = timestamp.to_i
  buses = bus_list.split(',').reject { |b| b == 'x' }.map(&:to_i)
  departures = buses.map { |bus| (timestamp / bus + 1) * bus }
  our_departure = departures.min
  buses[departures.index(our_departure)] * (our_departure - timestamp)
end

# Find the interval at which the condition is true for the first two buses.
# Once we know that, we can step forward at that interval and check for the
# third bus. That gives us the interval at which the first three buses will
# repeat. Repeat the process adding one more bus each time until we have them
# all.
def part_two(input)
  _, bus_list = input.split("\n") # discard first line
  buses = bus_list.split(',').map { |bus| bus == 'x' ? nil : bus.to_i }
  step = buses.first
  time = prev_time = 0

  buses.each_with_index do |bus, offset|
    next if bus.nil? # 'x' in original input
    next if offset.zero? # skip first bus

    index = 0
    found_once = false
    loop do
      if ((time + offset) % bus).zero?
        if found_once || bus == buses.last # don't need interval for last bus
          step = time - prev_time
          break
        else
          prev_time = time
          found_once = true
        end
      end
      time += step
      index += 1
    end
  end
  time
end

REAL_INPUT = import_from_file('puzz13_input.txt')

p part_one(TEST_INPUT) # should be 295
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 1068781
p part_two(REAL_INPUT)
