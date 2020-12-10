# frozen_string_literal: true

def import_from_file(filename)
  file = File.open(filename)
  file.readlines.map(&:chomp).map(&:to_i)
end

def part_one(input)
  (input << 0).sort! # account for 0 at the charging port
  ones = threes = 0
  previous = nil
  input.each do |adapter|
    if previous
      diff = adapter - previous
      ones += 1 if diff == 1
      threes += 1 if diff == 3
    end
    previous = adapter
  end
  ones * (threes + 1) # account for +3 to the device
end

def part_two(input)
  input << 0 # account for 0 at the charging port
  max = input.max
  num_paths = Array.new(max + 1, 0) # how many ways to get from here to target?
  num_paths[-1] = 1 # from target to target, one way to get there by definition
  nodes = Array.new(max, false) # map numbers to boolean array for faster lookup
  input.each { |item| nodes[item] = true }

  # Work backwards. Figure out the final approaches first, then build upon
  # that. If we know there are, e.g. 40000 ways to get from 100 to the target,
  # we don't have to keep recalculating those paths over and over.
  (0..max).reverse_each do |num|
    next unless nodes[num] # skip numbers that aren't in the list
    next if num_paths[num].positive? # we've already looked at this number

    # We can get from here to any of the next three numbers, so we can just
    # add the numbers of already-calculated paths from those numbers to the
    # target to figure out the number of paths from here.
    num_paths[num] = (1..3).map do |offset|
      num + offset > max ? 0 : num_paths[num + offset]
    end.reduce(&:+)
  end
  num_paths[0]
end

p part_one(import_from_file('puzz10_test1.txt')) # should be 35
p part_one(import_from_file('puzz10_test2.txt')) # should be 220
p part_one(import_from_file('puzz10_input.txt'))

p part_two(import_from_file('puzz10_test1.txt')) # should be 8
p part_two(import_from_file('puzz10_test2.txt')) # should be 19208
p part_two(import_from_file('puzz10_input.txt'))
