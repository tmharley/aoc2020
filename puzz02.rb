TEST_INPUT = [
  '1-3 a: abcde',
  '1-3 b: cdefg',
  '2-9 c: ccccccccc'
].freeze

REGEX = /(\d+)-(\d+) (\w): (\w+)/

def import_from_file(filename)
  file = File.open(filename)
  file.readlines.map(&:chomp)
end

def part_one(pwd_list)
  correct = 0

  pwd_list.each do |input|
    data = input.match(REGEX)
    min = data[1].to_i
    max = data[2].to_i
    letter = data[3]
    pwd = data[4]
    num_occurrences = pwd.split('').select { |c| c == letter }.length
    matched = (min..max).include?(num_occurrences)
    correct += 1 if matched
  end

  correct
end

def part_two(pwd_list)
  correct = 0

  pwd_list.each do |input|
    data = input.match(REGEX)
    index1 = data[1].to_i
    index2 = data[2].to_i
    letter = data[3]
    pwd = data[4]
    matched = (pwd[index1 - 1] == letter) ^ (pwd[index2 - 1] == letter)
    correct += 1 if matched
  end

  correct
end

input = import_from_file('puzz02_input.txt')

p part_one(TEST_INPUT) # should be 2
p part_one(input)

p part_two(TEST_INPUT) # should be 1
p part_two(input)
