TEST_INPUT = <<~INPUT.freeze
  0: 4 1 5
  1: 2 3 | 3 2
  2: 4 4 | 5 5
  3: 4 5 | 5 4
  4: "a"
  5: "b"
  
  ababbb
  bababa
  abbbab
  aaabbb
  aaaabbb
INPUT

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

# @param input the raw puzzle input
# @return an ordered list of rules, and an array of individual messages
def parse_input(input)
  rules = []
  raw_rules, raw_msgs = input.split("\n\n")
  raw_rules.split("\n").map do |line|
    rule_num, rule = line.split(': ')
    rules[rule_num.to_i] = rule
  end
  [rules, raw_msgs.split("\n")]
end

def compose_rule(rule_num, rules, special_cases: false)
  rule = rules[rule_num]
  new_rule = ''

  # No need to generalize, we'll just handle special cases directly.
  # Just substituting in direct regex translations, basically.
  if special_cases && [8, 11].include?(rule_num)
    new_rule = if rule_num == 8
                 "(#{compose_rule(42, rules)})+"
               else
                 # For rule 11: it's rule 42 repeated some number of times,
                 # followed by rule 31 repeated the same number of times.
                 # There's not really a clean way to do that, so this is a
                 # bit of a hack. Hopefully we won't have to do more than 5
                 # repeats.
                 (1..5).map do |n|
                   "(#{compose_rule(42, rules)}){#{n}}(#{compose_rule(31, rules)}){#{n}}"
                 end.join('|')
               end
  else
    rule.split(' ').each do |token|
      if /\d+/.match(token)
        new_rule << "(#{compose_rule(token.to_i, rules, special_cases: special_cases)})"
      elsif (md = /"(\w+)"/.match(token))
        new_rule << md[1]
      elsif token == '|'
        new_rule << '|'
      end
    end
  end
  new_rule
end

def part_one(input)
  rules, msgs = parse_input(input)
  rule = /\A#{compose_rule(0, rules)}\Z/
  msgs.map { |msg| rule.match(msg) ? 1 : 0 }.sum
end

def part_two(input)
  rules, msgs = parse_input(input)
  rule = /\A#{compose_rule(0, rules, special_cases: true)}\Z/
  msgs.map { |msg| rule.match(msg) ? 1 : 0 }.sum
end

REAL_INPUT = import_from_file('puzz19_input.txt')

p part_one(TEST_INPUT) # should return 2
p part_one(REAL_INPUT)

p part_two(REAL_INPUT)
