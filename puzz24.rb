# frozen_string_literal: true

require 'set'

def import_from_file(filename)
  file = File.open(filename)
  file.readlines.map(&:chomp)
end

def find_tile(directions)
  x = 0
  y = 0
  until directions == ''
    step = directions.slice!(0)
    case step
    when 'w'
      x -= 2
    when 'e'
      x += 2
    when 'n'
      y += 1
      directions.slice!(0) == 'w' ? x -= 1 : x += 1
    when 's'
      y -= 1
      directions.slice!(0) == 'w' ? x -= 1 : x += 1
    else
      raise 'invalid input'
    end
  end
  [x, y]
end

def initial_setup(input)
  black_tiles = Set.new
  input.each do |line|
    tile = find_tile(line)
    if black_tiles.include?(tile)
      black_tiles.delete(tile)
    else
      black_tiles << tile
    end
  end
  black_tiles
end

def simulate_day(starting_tiles)
  ending_tiles = starting_tiles.dup
  tiles_to_check = Set.new
  starting_tiles.each do |t|
    to_add = [t] + adjacent_tiles(t)
    to_add.each { |tt| tiles_to_check << tt }
  end
  tiles_to_check.each do |t|
    if starting_tiles.include?(t)
      unless [1, 2].include?((starting_tiles & adjacent_tiles(t)).length)
        ending_tiles.delete(t)
      end
    elsif (starting_tiles & adjacent_tiles(t)).length == 2
      ending_tiles << t
    end
  end
  ending_tiles
end

def adjacent_tiles(tile)
  loc_x = tile[0]
  loc_y = tile[1]
  [
    [loc_x - 1, loc_y - 1],
    [loc_x + 1, loc_y - 1],
    [loc_x - 1, loc_y + 1],
    [loc_x + 1, loc_y + 1],
    [loc_x - 2, loc_y],
    [loc_x + 2, loc_y]
  ]
end

def part_one(input)
  initial_setup(input).length
end

def part_two(input)
  black_tiles = initial_setup(input)
  100.times { black_tiles = simulate_day(black_tiles) }
  black_tiles.length
end

p part_one(import_from_file('puzz24_test.txt')) # should return 10
p part_one(import_from_file('puzz24_input.txt'))

p part_two(import_from_file('puzz24_test.txt')) # should return 2208
p part_two(import_from_file('puzz24_input.txt'))
