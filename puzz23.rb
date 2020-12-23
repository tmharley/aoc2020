# frozen_string_literal: true

TEST_INPUT = '389125467'
REAL_INPUT = '974618352'

def move(cups, current)
  max_value = cups.max + 1
  curr_index = cups.index(current)
  picked_up = cups.slice!(curr_index + 1, 3)
  if (num_picked_up = picked_up.length) < 3
    picked_up += cups.shift(3 - num_picked_up)
  end
  # p 'pick up: ' + picked_up.join(', ')
  destination = current - 1
  until cups.include?(destination)
    destination = (destination - 1) % max_value
  end
  # p "destination: #{destination}"
  cups.insert(cups.index(destination) + 1, picked_up)
  cups.flatten!
end

def play_game(cups, moves)
  current_cup = cups.first
  (1..moves).each do |i|
    p "-- move #{i} --" if i % 100 == 0
    # p 'cups: ' + cups.map { |c| c == current_cup ? "(#{c})" : c }.join(' ')
    move(cups, current_cup)
    current_cup = cups[(cups.index(current_cup) + 1) % cups.length]
  end
  cups
end

def part_one(input, moves)
  cups = play_game(input.split('').map(&:to_i), moves)
  cup_one = cups.index(1)
  cups[cup_one + 1..-1].join('') + cups[0...cup_one].join('')
end

def part_two(input, moves)
  original_cups = input.split('').map(&:to_i)
  cups = (1...1_000_000).map do |n|
    n < original_cups.length ? original_cups[n - 1] : n
  end
  cups = play_game(cups, moves)
end

p part_one(TEST_INPUT, 10) # should return 92658374
p part_one(REAL_INPUT, 100)

p part_two(TEST_INPUT, 10_000_000) # should return 149245887792
