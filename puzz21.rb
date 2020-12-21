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
  stuff = dishes.map do |dish|
    ingredients_list, allergens_list = dish.split(' (contains ')
    h = { ingredients: Set.new, allergens: Set.new }
    ingredients_list.split(' ').each { |i| h[:ingredients] << i }
    allergens_list[0...-1].split(', ').each do |a|
      h[:allergens] << a
      all_allergens << a
    end
    h
  end
  [stuff, all_allergens]
end

def process(input)
  dishes, allergens = parse_input(input)
  matches = {}
  loop do
    outstanding_allergens = allergens.reject { |a| matches.keys.include?(a) }
    break if outstanding_allergens.empty?

    outstanding_allergens.each do |a|
      # p "Looking for allergen #{a}"
      possible = Set.new
      dishes.each do |d|
        if d[:allergens].include?(a)
          possible.empty? ? possible += d[:ingredients] : possible &= d[:ingredients]
        end
        possible -= matches.values
        # p "Possibilities: #{possible}"
        next if possible.size != 1

        matches[a] = possible.to_a[0]
        break
      end
    end
  end
  total = 0
  dishes.each do |d|
    total += d[:ingredients].reject { |i| matches.values.include?(i) }.length
  end
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
