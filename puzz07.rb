# frozen_string_literal: true

require 'set'

TEST_INPUT = <<~INPUT
  light red bags contain 1 bright white bag, 2 muted yellow bags.
  dark orange bags contain 3 bright white bags, 4 muted yellow bags.
  bright white bags contain 1 shiny gold bag.
  muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
  shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
  dark olive bags contain 3 faded blue bags, 4 dotted black bags.
  vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
  faded blue bags contain no other bags.
  dotted black bags contain no other bags.
INPUT

def import_from_file(filename)
  file = File.open(filename)
  file.readlines.map(&:chomp)
end

def test_input
  TEST_INPUT.split("\n")
end

# @param color the color bag being searched for
# @param rules array containing the list of individual bag rules
def find_containing_bags(color, rules)
  allowed_colors = Set.new
  rules.map { |rule| rule.split('contain') }
       .each do |rule_color, contents|
    if contents.include?(color)
      allowed_colors.add(rule_color)
      allowed_colors.merge(find_containing_bags(rule_color[0...rule_color.length - 2], rules))
    end
  end
  allowed_colors
end

def multiple_bag_parse(text)
  text.chomp!
  return [] if text == 'no other bags'

  quantity = text.to_i
  color = text.split(' ')[1..2].join(' ')
  Array.new(quantity, color)
end

def rules_to_hash(rules_text)
  rules_text.map { |rule| rule.split('contain') }
            .map do |rule_color, contents|
    rc = rule_color.split(' ')[0..1].join(' ')
    cont = contents.split(',').map { |c| multiple_bag_parse(c) }.reduce(&:+)
    [rc, cont]
  end.to_h
end

def part_one(color, input)
  find_containing_bags(color, input).size
end

def part_two(color, input)
  bags_to_check = []
  total_bags = 0
  parsed_rules = rules_to_hash(input)
  bags_to_check += parsed_rules[color]
  total_bags += bags_to_check.length
  while bags_to_check.any?
    new_bags = parsed_rules[bags_to_check.shift]
    total_bags += new_bags.length
    bags_to_check += new_bags
  end
  total_bags
end

real_input = import_from_file('puzz07_input.txt')

p part_one('shiny gold', test_input) # should be 4
p part_one('shiny gold', real_input)

p part_two('shiny gold', test_input) # should be 32
p part_two('shiny gold', real_input)
