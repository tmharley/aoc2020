# frozen_string_literal: true

TEST_INPUT = <<~INPUT
  abc

  a
  b
  c

  ab
  ac

  a
  a
  a
  a

  b
INPUT

ALPHA_TO_INDEX = Hash[('a'..'z').to_a.zip((0..25).to_a)]

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

def process_group(input)
  result = [false] * 26
  ('a'..'z').each do |letter|
    result[ALPHA_TO_INDEX[letter]] = true if input.include?(letter)
  end
  result.count { |found| found }
end

def process_group_unanimous(input)
  lines = input.split("\n")
  letters = lines.shift.split('')
  lines.each do |line|
    letters.keep_if { |letter| line.include?(letter) }
    break if letters.empty?
  end
  letters.size
end

def part_one(input)
  input.split("\n\n").map { |group| process_group(group) }.reduce(&:+)
end

def part_two(input)
  input.split("\n\n").map { |group| process_group_unanimous(group) }.reduce(&:+)
end

puzzle_input = import_from_file('puzz06_input.txt')

p part_one(TEST_INPUT) # should be 11
p part_one(puzzle_input)

p part_two(TEST_INPUT) # should be 6
p part_two(puzzle_input)
