# frozen_string_literal: true

TEST_INPUT = <<~INPUT
  ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
  byr:1937 iyr:2017 cid:147 hgt:183cm

  iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
  hcl:#cfa07d byr:1929

  hcl:#ae17e1 iyr:2013
  eyr:2024
  ecl:brn pid:760753108 byr:1931
  hgt:179cm

  hcl:#cfa07d eyr:2025 pid:166559648
  iyr:2011 ecl:brn hgt:59in
INPUT
TEST_INPUT.freeze

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

def validate_field(field, value)
  case field
  when 'byr'
    (1920..2002).include?(value.to_i)
  when 'iyr'
    (2010..2020).include?(value.to_i)
  when 'eyr'
    (2020..2030).include?(value.to_i)
  when 'hgt'
    if value.end_with?('cm')
      (150..193).include?(value.to_i)
    elsif value.end_with?('in')
      (59..76).include?(value.to_i)
    else
      false
    end
  when 'hcl'
    /\A#\h{6}\Z/.match?(value)
  when 'ecl'
    %w[amb blu brn gry grn hzl oth].include?(value)
  when 'pid'
    /\A\d{9}\Z/.match?(value)
  when 'cid'
    true
  else
    false
  end
end

def validate_passport(passport)
  cid_found = false
  fields = passport.split(/\s/)
  return false if fields.length < 7

  fields.each do |field|
    name, value = field.split(':')
    cid_found ||= name == 'cid'
    return false unless validate_field(name, value)
  end
  fields.length == 8 || !cid_found
end

def part_one(input)
  passports = input.split("\n\n")
  valid_passports = 0
  passports.each do |passport|
    fields = passport.split(/\s/)
    next if fields.reject { |f| f.start_with?('cid') }.length < 7

    valid_passports += 1
  end
  valid_passports
end

def part_two(input)
  passports = input.split("\n\n")
  valid_passports = 0
  passports.each do |passport|
    valid_passports += 1 if validate_passport(passport)
  end
  valid_passports
end

data = import_from_file('puzz04_input.txt')

p part_one(TEST_INPUT) # should return 2
p part_one(data)
p part_two(data)
