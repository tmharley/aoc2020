# frozen_string_literal: true

DIRECTIONS = [
  { delta_x: -1, delta_y: -1 },
  { delta_x: 0, delta_y: -1 },
  { delta_x: 1, delta_y: -1 },
  { delta_x: 1, delta_y: 0 },
  { delta_x: 1, delta_y: 1 },
  { delta_x: 0, delta_y: 1 },
  { delta_x: -1, delta_y: 1 },
  { delta_x: -1, delta_y: 0 }
].freeze

def import_from_file(filename)
  file = File.open(filename)
  file.readlines.map(&:chomp)
end

# @param input raw text input, where L is an open seat, # an occupied seat, . no seat
# @return array where false is an open seat, true an occupied seat, nil no seat
def text_to_seats(input)
  input.map do |line|
    line.split('').map do |location|
      case location
      when '.' then nil
      when 'L' then false
      when '#' then true
      end
    end
  end
end

def surrounding_seats_occupied(x, y, grid)
  count = 0
  ((x - 1)..(x + 1)).each do |i|
    ((y - 1)..(y + 1)).each do |j|
      next unless in_bounds?(i, j, grid)
      next if x == i && y == j

      count += 1 if grid[i][j]
    end
  end
  count
end

def visible_seats_occupied(x, y, grid)
  count = 0
  DIRECTIONS.each do |dir|
    xx = x + dir[:delta_x]
    yy = y + dir[:delta_y]
    while in_bounds?(xx, yy, grid)
      break if grid[xx][yy] == false

      if grid[xx][yy]
        count += 1
        break
      end
      xx += dir[:delta_x]
      yy += dir[:delta_y]
    end
  end
  count
end

def in_bounds?(x, y, grid)
  (0...grid.length).include?(x) && (0...grid.first.length).include?(y)
end

def seat_available?(x, y, grid, adjacent: true)
  if adjacent
    surrounding_seats_occupied(x, y, grid).zero?
  else
    visible_seats_occupied(x, y, grid).zero?
  end
end

def seat_overcrowded?(x, y, grid, tolerance: 4, adjacent: true)
  if adjacent
    surrounding_seats_occupied(x, y, grid) >= tolerance
  else
    visible_seats_occupied(x, y, grid) >= tolerance
  end
end

def simulate(input, tolerance: 4, adjacent: true)
  grid = text_to_seats(input)
  occupied = 0
  loop do
    now_occupied = 0
    snapshot = grid.map(&:dup)
    (0...grid.length).each do |x|
      (0...grid.first.length).each do |y|
        next if grid[x][y].nil?

        if grid[x][y]
          if seat_overcrowded?(x, y, snapshot,
                               tolerance: tolerance, adjacent: adjacent)
            grid[x][y] = false
          end
        else
          grid[x][y] = seat_available?(x, y, snapshot, adjacent: adjacent)
        end
        now_occupied += 1 if grid[x][y]
      end
    end
    return now_occupied if now_occupied == occupied

    occupied = now_occupied
  end
end

def part_one(input)
  simulate(input)
end

def part_two(input)
  simulate(input, tolerance: 5, adjacent: false)
end

TEST_INPUT = import_from_file('puzz11_test.txt')
REAL_INPUT = import_from_file('puzz11_input.txt')

p part_one(TEST_INPUT) # should be 37
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 26
p part_two(REAL_INPUT)
