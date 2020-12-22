# frozen_string_literal: true

def import_from_file(filename)
  file = File.open(filename)
  file.readlines.map(&:chomp)
end

TEST_INPUT = import_from_file('puzz22_test.txt')
TEST_INPUT_2 = import_from_file('puzz22_test2.txt')
REAL_INPUT = import_from_file('puzz22_input.txt')

def split_decks(input)
  cards1 = []
  cards2 = []
  current_player = nil
  input.each do |line|
    next if line == ''

    if line.start_with?('Player')
      current_player = line[-2].to_i
    else
      pile = current_player == 1 ? cards1 : cards2
      pile << line.to_i
    end
  end
  [cards1, cards2]
end

def play_round(round_num, deck1, deck2, recursive: false)
  round_winner = nil
  p "-- Round #{round_num} --"
  p "Player 1's deck: #{deck1.join(', ')}"
  p "Player 2's deck: #{deck2.join(', ')}"
  play1 = deck1.shift
  play2 = deck2.shift
  p "Player 1 plays: #{play1}"
  p "Player 2 plays: #{play2}"
  if recursive && deck1.length >= play1 && deck2.length >= play2
    d1, _d2, recursive_winner = play_game(deck1[0...play1],
                                          deck2[0...play2],
                                          recursive: true)
    round_winner = recursive_winner == d1 ? deck1 : deck2
  elsif play1 > play2
    p 'Player 1 wins the round!'
    round_winner = deck1
  else
    p 'Player 2 wins the round!'
    round_winner = deck2
  end
  if round_winner == deck1
    deck1 << play1 << play2
  else
    deck2 << play2 << play1
  end
  [deck1, deck2]
end

def play_game(deck1, deck2, recursive: false)
  round = 0
  found_loop = false
  previous_configs = []
  while deck1.any? && deck2.any?
    if previous_configs.include?([deck1, deck2])
      # we're in a loop, player 1 wins
      found_loop = true
      break
    end
    previous_configs << [deck1.dup, deck2.dup]
    round += 1
    play_round(round, deck1, deck2, recursive: recursive)
  end
  p '== Post-game results =='
  p "Player 1's deck: #{deck1.join(', ')}"
  p "Player 2's deck: #{deck2.join(', ')}"
  winner = if found_loop || deck1.any?
             deck1
           else
             deck2
           end
  [deck1, deck2, winner]
end

def part_one(input)
  _, _, winner = play_game(*split_decks(input))
  (0...winner.length).map { |n| winner[n] * (winner.length - n) }.reduce(&:+)
end

def part_two(input)
  _, _, winner = play_game(*split_decks(input), recursive: true)
  (0...winner.length).map { |n| winner[n] * (winner.length - n) }.reduce(&:+)
end

p part_one(TEST_INPUT) # should return 306
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should return 291
p part_two(TEST_INPUT_2) # for testing infinite loop detection
p part_two(REAL_INPUT)
