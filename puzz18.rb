# frozen_string_literal: true

TEST_INPUT = [
  '1 + (2 * 3) + (4 * (5 + 6))',
  '2 * 3 + (4 * 5)',
  '5 + (8 * 3 + 9 + 3 * 4 * 3)',
  '5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))',
  '((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2'
].freeze

def import_from_file(filename)
  file = File.open(filename)
  file.readlines.map(&:chomp)
end

def preprocess(input)
  input.gsub('(', '( ( ').gsub(')', ' ) )')
end

def preprocess2(input)
  "( #{preprocess(input).gsub('*', ') * (')} )"
end

def evaluate(tokens)
  value = nil
  operator = nil
  while tokens.any?
    token = tokens.shift
    case token
    when ')'
      return value
    when '('
      operand = evaluate(tokens)
      value = value ? value.send(operator, operand) : operand
    when '+', '*'
      operator = token
    else
      if value.nil?
        value = token.to_i
      else
        value = value.send(operator, token.to_i)
        operator = nil
      end
    end
  end
  value
end

REAL_INPUT = import_from_file('puzz18_input.txt')

def part_one(input)
  Array(input).map { |expr| evaluate(preprocess(expr).split(' ')) }.sum
end

def part_two(input)
  Array(input).map { |expr| evaluate(preprocess2(expr).split(' ')) }.sum
end

p part_one(TEST_INPUT) # should return 51 + 26 + 437 + 12240 + 13632 = 26386
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should return 51 + 46 + 1445 + 669060 + 23340 = 693942
p part_two(REAL_INPUT)
