# frozen_string_literal: true

require 'set'

TEST_INPUT = <<~INPUT
  mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
  trh fvjkl sbzzf mxmxvkd (contains dairy)
  sqjhc fvjkl (contains soy)
  sqjhc mxmxvkd sbzzf (contains fish)
INPUT

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

def parse_input(input)
  dishes = input.split("\n")
  all_allergens = Set.new
  dishes = dishes.map do |dish|
    ingredients_list, allergens_list = dish.split(' (contains ')
    dish = { ingredients: Set.new, allergens: Set.new }
    ingredients_list.split(' ').each { |i| dish[:ingredients] << i }
    allergens_list[0...-1].split(', ').each do |a|
      dish[:allergens] << a
      all_allergens << a
    end
    dish
  end
  [dishes, all_allergens]
end

def process(input)
  dishes, allergens = parse_input(input)
  matches = {}
  loop do
    allergens.reject! { |a| matches.keys.include?(a) }
    break if allergens.empty?

    allergens.each do |a|
      possible = Set.new
      dishes.each do |dish|
        if dish[:allergens].include?(a)
          if possible.empty?
            possible += dish[:ingredients]
          else
            possible &= dish[:ingredients]
          end
        end
        possible -= matches.values
        next if possible.size != 1

        matches[a] = possible.to_a[0]
        break
      end
    end
  end
  total = dishes.map do |d|
    d[:ingredients].reject { |i| matches.values.include?(i) }.length
  end.reduce(&:+)
  [total, matches]
end

def part_one(input)
  process(input)[0]
end

def part_two(input)
  matches = process(input)[1]
  matches.keys.sort.map { |k| matches[k] }.join(',')
end

REAL_INPUT = import_from_file('puzz21_input.txt')

p part_one(TEST_INPUT) # should return 5
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should return 'mxmxvkd,sqjhc,fvjkl'
p part_two(REAL_INPUT)
