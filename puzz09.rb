# frozen_string_literal: true

def import_from_file(filename)
  file = File.open(filename)
  file.readlines.map(&:chomp).map(&:to_i)
end

def valid_sum?(sum, inputs)
  inputs.each do |x|
    inputs.each do |y|
      return true if x != y && x + y == sum
    end
  end
  false
end

# @param list the full list of numbers output by XMAS
# @param lookback the number of previous entries that are valid inputs to the function
# Note: the preamble is assumed to have the same length as +lookback+.
def part_one(list, lookback)
  inputs = []
  list.each_with_index do |entry, index|
    if index < lookback
      inputs << entry
      next
    end
    return entry unless valid_sum?(entry, inputs)

    (inputs << entry).shift
  end
  raise ArgumentError, 'no invalid entries found'
end

def part_two(list, lookback)
  invalid_item = part_one(list, lookback)
  list.each_with_index do |entry, index|
    min = max = sum = entry
    index2 = index
    until sum >= invalid_item
      index2 += 1
      sum += (next_entry = list[index2])
      min = min > next_entry ? next_entry : min
      max = max < next_entry ? next_entry : max
    end
    return min + max if sum == invalid_item
  end
  raise ArgumentError, 'no conforming sequence found'
end

TEST_INPUT = import_from_file('puzz09_test.txt')
REAL_INPUT = import_from_file('puzz09_input.txt')

p part_one(TEST_INPUT, 5) # should return 127
p part_one(REAL_INPUT, 25)

p part_two(TEST_INPUT, 5) # should return 62
p part_two(REAL_INPUT, 25)
