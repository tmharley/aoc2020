SUM_VALUE = 2020

def import_from_file(filename)
  file = File.open(filename)
  file.readlines.map(&:chomp).map(&:to_i)
end

def part_one
  expenses = import_from_file('puzz01_1_input.txt')
  expenses.each do |num|
    expenses.each do |num2|
      return num * num2 if num + num2 == SUM_VALUE
    end
  end
end

def part_two
  expenses = import_from_file('puzz01_1_input.txt')
  expenses.each do |num|
    expenses.each do |num2|
      expenses.each do |num3|
        return num * num2 * num3 if num + num2 + num3 == SUM_VALUE
      end
    end
  end
end

p part_one
p part_two