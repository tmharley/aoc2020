# frozen_string_literal: true

TEST_INPUT = %w[
  ..##.........##.........##.........##.........##.........##.......
  #...#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
  .#....#..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
  ..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
  .#...##..#..#...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
  ..#.##.......#.##.......#.##.......#.##.......#.##.......#.##.....
  .#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
  .#........#.#........#.#........#.#........#.#........#.#........#
  #.##...#...#.##...#...#.##...#...#.##...#...#.##...#...#.##...#...
  #...##....##...##....##...##....##...##....##...##....##...##....#
  .#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#
].freeze

def import_from_file(filename)
  file = File.open(filename)
  file.readlines.map(&:chomp)
end

def part_one(input, delta_x, delta_y)
  x = y = 0
  trees = 0
  while y < input.length
    trees += 1 if input[y][x] == '#'
    x = (x + delta_x) % input.first.length
    y += delta_y
  end
  trees
end

def part_two(input)
  [
    { x: 1, y: 1 },
    { x: 3, y: 1 },
    { x: 5, y: 1 },
    { x: 7, y: 1 },
    { x: 1, y: 2 }
  ].map { |slope| part_one(input, slope[:x], slope[:y]) }.reduce(&:*)
end

data = import_from_file('puzz03_input.txt')

p part_one(TEST_INPUT, 3, 1) # should return 7
p part_one(data, 3, 1)

p part_two(TEST_INPUT) # should return 336
p part_two(data)
