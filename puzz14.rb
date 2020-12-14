# frozen_string_literal: true

TEST_INPUT = <<~INPUT
  mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
  mem[8] = 11
  mem[7] = 101
  mem[8] = 0
INPUT

TEST_INPUT_2 = <<~INPUT
  mask = 000000000000000000000000000000X1001X
  mem[42] = 100
  mask = 00000000000000000000000000000000X0XX
  mem[26] = 1
INPUT

def import_from_file(filename)
  file = File.open(filename)
  file.readlines.map(&:chomp)
end

# @return two bitmasks, one with the 1s (for |) and one with the 0s (for &)
def parse_mask(mask)
  mask0 = mask.gsub('X', '1').to_i(2)
  mask1 = mask.gsub('X', '0').to_i(2)
  [mask0, mask1]
end

# @param mask the bitmask with which to modify the memory address
# @param input the initial memory address to be modified
# @return all memory addresses resulting from masking +input+ with +mask+
def parse_mask_v2(mask, input)
  binary_input = input.to_s(2)
  full_mask = '?' * mask.length
  index = 0
  offset = mask.length - binary_input.length
  (0...mask.length).each do
    if index < offset
      full_mask[index] = mask[index]
    else
      digit = binary_input[index - offset]
      full_mask[index] = if mask[index] == 'X'
                           'X'
                         else
                           (digit.to_i | mask[index].to_i).to_s
                         end
    end
    index += 1
  end
  build_floating_masks(full_mask).map { |m| m.to_i(2) }
end

def build_floating_masks(input)
  str0 = input.sub('X', '0')
  str1 = input.sub('X', '1')
  output = []
  if str0.index('X')
    output << build_floating_masks(str0) << build_floating_masks(str1)
  else
    output << str0 << str1
  end
  output.flatten
end

def part_one(input)
  mask0 = mask1 = nil
  mem = {}
  input.each do |line|
    item, value = line.split('=').map(&:strip)
    if item == 'mask'
      mask0, mask1 = parse_mask(value)
    else
      index = item[4..-2].to_i
      mem[index] = (value.to_i & mask0) | mask1
    end
  end
  mem.values.sum { |x| x || 0 }
end

def part_two(input)
  mask = nil
  mem = {}
  input.each do |line|
    item, value = line.split('=').map(&:strip)
    if item == 'mask'
      mask = value
    else
      initial_loc = item[4..-2].to_i
      mem_locations = parse_mask_v2(mask, initial_loc)
      mem_locations.each { |loc| mem[loc] = value.to_i }
    end
  end
  mem.values.sum { |x| x || 0 }
end

REAL_INPUT = import_from_file('puzz14_input.txt')

p part_one(TEST_INPUT.split("\n")) # should return 165
p part_one(REAL_INPUT)

p part_two(TEST_INPUT_2.split("\n")) # should return 208
p part_two(REAL_INPUT)
