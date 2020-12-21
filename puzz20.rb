# frozen_string_literal: true

NORTH = 0
EAST = 1
SOUTH = 2
WEST = 3

SEA_MONSTER = ['                  # ',
               '#    ##    ##    ###',
               ' #  #  #  #  #  #   '].freeze

class Tile
  attr_reader :id, :edges, :rotations

  def initialize(raw_input)
    input = raw_input.split("\n")
    @id = input.shift[5..-2].to_i
    @rotations = 0
    @lines = input
    @edges = [@lines.first,
              @lines.map { |l| l[-1] }.join(''),
              @lines.last.reverse,
              @lines.map { |l| l[0] }.join('').reverse]
    @matching_tiles = Array.new(4)
  end

  def strip_borders
    dup.strip_borders!
  end

  def strip_borders!
    @lines = @lines[1...-1].map { |line| line[1...-1] }
  end

  def edge(direction)
    @edges[(direction + @rotations) % 4]
  end

  def rotate
    @rotations += 1
    self
  end

  def set_match(direction, matching_tile)
    @matching_tiles[direction] = matching_tile
  end

  def matching_tile(direction)
    @matching_tiles[(direction + @rotations) % 4]
  end

  def lines
    case @rotations % 4
    when 0
      @lines
    when 1
      length = @lines.length
      new_lines = @lines.map(&:dup)
      (0...length).each do |x|
        (0...length).each do |y|
          new_lines[y][length - x - 1] = @lines[x][y]
        end
      end
      new_lines
    when 2
      @lines.reverse.map(&:reverse)
    when 3
      length = @lines.length
      new_lines = @lines.map(&:dup)
      (0...length).each do |x|
        (0...length).each do |y|
          new_lines[y][length - x - 1] = @lines[x][y]
        end
      end
      new_lines.reverse.map(&:reverse)
    end
  end

  def line_length
    @lines.length
  end

  def to_s
    lines.join("\n")
  end
end

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

def extract_tiles(input)
  input.split("\n\n").map { |t| Tile.new(t) }
end

def find_matches(tiles)
  corners = []

  matches = tiles.map do |tile|
    { tile.id => Array.new(4, nil) }
  end.reduce(&:merge!)

  tiles.each do |tile|
    edges = tile.edges
    matching_edges = 0
    [NORTH, EAST, SOUTH, WEST].each do |i|
      tiles.each do |tile2|
        edges2 = tile2.edges
        next if tile2.id == tile.id

        [NORTH, EAST, SOUTH, WEST].each do |j|
          next unless edges[i] == edges2[j] || edges[i] == edges2[j].reverse

          matching_edges += 1
          matches[tile.id][i] = tile2.id
          tile.set_match(i, tile2)
        end
      end
    end
    corners << tile.id if matches[tile.id].compact.size == 2
  end
  matches
end

def find_corners(matches)
  matches.select { |k, v| v.compact.size == 2 }
end

def corner?(x, y, grid_size)
  [0, grid_size - 1].include?(x) && [0, grid_size - 1].include?(y)
end

def edge?(x, y, grid_size)
  ([0, grid_size - 1].include?(x) || [0, grid_size - 1].include?(y)) &&
    !corner?(x, y, grid_size)
end

def corresponding_direction(direction)
  (direction + 2) % 4
end

def bordering_cell(x, y, direction, grid)
  case direction
  when NORTH
    x.zero? ? [nil, nil] : [x - 1, y]
  when EAST
    y == grid.length - 1 ? [nil, nil] : [x, y + 1]
  when SOUTH
    x == grid.length - 1 ? [nil, nil] : [x + 1, y]
  when WEST
    y.zero? ? [nil, nil] : [x, y - 1]
  end
end

def find_sea_monsters(lines)
  count = 0
  (0...lines.length).each do |i|
    if (idx = lines[i].index(SEA_MONSTER[0]))
      if idx == lines[i + 1].index(SEA_MONSTER[1]) && idx == lines[i + 2].index(SEA_MONSTER[2])
        count += 1
      end
    end
  end
  count
end

def part_one(input)
  tiles = extract_tiles(input)
  matches = find_matches(tiles)
  find_corners(matches).keys.reduce(&:*)
end

def part_two(input)
  tiles = extract_tiles(input)
  grid_size = Math.sqrt(tiles.length)
  grid = Array.new(grid_size) { Array.new(grid_size) { 0 } }
  matches = find_matches(tiles)
  corners = find_corners(matches)

  grid[0][0] = tiles.select { |t| t.matching_tile(WEST).nil? && t.matching_tile(NORTH).nil? }.first

  (0...grid_size).each do |x|
    (0...grid_size).each do |y|
      cell = grid[x][y]
      next unless cell

      [NORTH, EAST, SOUTH, WEST].each do |direction|
        bcx, bcy = bordering_cell(x, y, direction, grid)
        next if bcx.nil?
        next if grid[bcx][bcy].is_a? Tile

        match = cell.matching_tile(direction)
        next unless match

        until match.matching_tile(corresponding_direction(direction)) == cell
          match.rotate
        end

        grid[bcx][bcy] = match
        p "Setting grid[#{bcx}][#{bcy}] to tile #{match.id} with #{match.rotations} rotations"
      end
    end
  end

  monster_count = 0
  grid.map { |row| row.map(&:strip_borders!) }
  [NORTH, EAST, SOUTH, WEST].each do |orientation|
    sea = grid.map do |row|
      (0...grid[0][0].line_length).map do |i|
        row.map { |tile| tile.rotate.lines[i] }.join('')
      end
    end.flatten!
    monster_count = find_sea_monsters(sea)
    return monster_count if monster_count.positive?
  end
  monster_count
end

TEST_INPUT = import_from_file('puzz20_test.txt')
REAL_INPUT = import_from_file('puzz20_input.txt')

p part_one(TEST_INPUT) # should return 1951 * 3079 * 2971 * 1171 = 20899048083289
p part_one(REAL_INPUT)

p part_two(TEST_INPUT)

# part_two(TEST_INPUT).each do |row|
#   row.each { |line| p line }
# end

