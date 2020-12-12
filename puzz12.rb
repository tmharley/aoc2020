# frozen_string_literal: true

NORTH = 0
EAST = 1
SOUTH = 2
WEST = 3

DIRECTIONS = [
  { x: 0, y: 1 },
  { x: 1, y: 0 },
  { x: 0, y: -1 },
  { x: -1, y: 0 }
].freeze

TEST_INPUT = <<~INPUT
  F10
  N3
  F7
  R90
  F11
INPUT

def import_from_file(filename)
  file = File.open(filename)
  file.readlines.map(&:chomp)
end

def part_one(input)
  x = y = 0
  direction = EAST
  input.each do |line|
    instruction = line[0]
    amount = line[1...line.length].to_i
    case instruction
    when 'N'
      y += amount
    when 'E'
      x += amount
    when 'S'
      y -= amount
    when 'W'
      x -= amount
    when 'L'
      direction = (direction - amount / 90) % 4
    when 'R'
      direction = (direction + amount / 90) % 4
    when 'F'
      x += DIRECTIONS[direction][:x] * amount
      y += DIRECTIONS[direction][:y] * amount
    end
    p "After #{line}, location is (#{x}, #{y})"
  end
  x.abs + y.abs
end

# To make math easier, represent the waypoint location as a complex number.
# Real part = x relative to the ship, imaginary part = y.
def part_two(input)
  x = y = 0
  waypoint_location = Complex(10, 1)
  input.each do |line|
    instruction = line[0]
    amount = line[1...line.length].to_i
    if instruction == 'F'
      x += waypoint_location.real * amount
      y += waypoint_location.imaginary * amount
    else
      waypoint_location = move_waypoint(waypoint_location, instruction, amount)
    end
    p "After #{line}, location is (#{x}, #{y})"
  end
  x.abs + y.abs
end

def move_waypoint(waypoint_location, instruction, amount)
  case instruction
  when 'N'
    waypoint_location + Complex(0, amount)
  when 'E'
    waypoint_location + Complex(amount, 0)
  when 'S'
    waypoint_location - Complex(0, amount)
  when 'W'
    waypoint_location - Complex(amount, 0)
  when 'L'
    Complex.polar(waypoint_location.magnitude,
                  waypoint_location.angle + Math::PI / 180 * amount)
  when 'R'
    Complex.polar(waypoint_location.magnitude,
                  waypoint_location.angle - Math::PI / 180 * amount)
  end
end

REAL_INPUT = import_from_file('puzz12_input.txt')

p part_one(TEST_INPUT.split("\n")) # should return 25
p part_one(REAL_INPUT)

p part_two(TEST_INPUT.split("\n")) # should return 286
p part_two(REAL_INPUT)
