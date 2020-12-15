# frozen_string_literal: true

TEST_INPUT = [0, 3, 6].freeze
REAL_INPUT = [7, 14, 0, 17, 11, 1, 2].freeze

def next_number(last_appearances, previous_number, last_turn)
  last_instance = last_appearances[previous_number] || 0
  last_appearances[previous_number] = last_turn
  last_instance.zero? ? 0 : last_turn - last_instance
end

def find_nth_number(input, n)
  last_appearances = Array.new(input.max, 0)
  turn = 0
  new_number = nil

  # handle starting input
  input.each_with_index do |num, index|
    turn += 1
    last_appearances[num] = turn unless index == input.length - 1
    new_number = num
  end

  until turn == n
    new_number = next_number(last_appearances, new_number, turn)
    turn += 1
  end
  new_number
end

def part_one(input)
  find_nth_number(input, 2020)
end

def part_two(input)
  find_nth_number(input, 30_000_000)
end

p part_one(TEST_INPUT) # should return 436
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should return 175594
p part_two(REAL_INPUT)

