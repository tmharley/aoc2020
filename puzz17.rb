# frozen_string_literal: true

require 'set'

TEST_INPUT = <<~INPUT
  .#.
  ..#
  ###
INPUT

def parse_input(input)
  rows = input.split("\n").map(&:chomp)
  offset = rows.length / 2
  active = Set.new
  rows.each_with_index do |row, x|
    row.split('').each_with_index do |col, y|
      active << [x - offset, y - offset, 0, 0] if col == '#'
    end
  end
  active
end

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

def neighbors(point, is4d: false)
  set = Set.new
  x, y, z, w = *point
  (x - 1..x + 1).each do |xx|
    (y - 1..y + 1).each do |yy|
      (z - 1..z + 1).each do |zz|
        if is4d
          (w - 1..w + 1).each do |ww|
            unless x == xx && y == yy && z == zz && w == ww
              set << [xx, yy, zz, ww]
            end
          end
        else
          set << [xx, yy, zz, 0] unless x == xx && y == yy && z == zz
        end
      end
    end
  end
  set
end

def get_extents(all_actives, is4d: false)
  act = all_actives.to_a
  x = act.map { |a| a[0] }
  y = act.map { |a| a[1] }
  z = act.map { |a| a[2] }
  w = is4d ? act.map { |a| a[3] } : nil
  x_range = (x.min - 1)..(x.max + 1)
  y_range = (y.min - 1)..(y.max + 1)
  z_range = (z.min - 1)..(z.max + 1)
  w_range = is4d ? (w.min - 1)..(w.max + 1) : (0..0)
  [x_range, y_range, z_range, w_range]
end

def simulate(input, is4d: false)
  actives = parse_input(input)
  6.times do
    new_actives = actives.dup
    check_x, check_y, check_z, check_w = get_extents(actives, is4d: is4d)
    check_x.each do |x|
      check_y.each do |y|
        check_z.each do |z|
          check_w.each do |w|
            point = [x, y, z, w]
            active = actives.include?(point)
            all_neighbors = neighbors(point, is4d: is4d)
            active_neighbors = all_neighbors & actives
            if active
              unless (2..3).include?(active_neighbors.size)
                new_actives.delete(point)
              end
            elsif active_neighbors.size == 3
              new_actives << point
            end
          end
        end
      end
    end
    actives = new_actives
  end
  actives.size
end

def part_one(input)
  simulate(input, is4d: false)
end

def part_two(input)
  simulate(input, is4d: true)
end

REAL_INPUT = import_from_file('puzz17_input.txt')

p part_one(TEST_INPUT) # should be 112
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 848
p part_two(REAL_INPUT)
