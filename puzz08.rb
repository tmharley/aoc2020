# frozen_string_literal: true

TEST_INPUT = <<~INPUT
  nop +0
  acc +1
  jmp +4
  acc +3
  jmp -3
  acc -99
  acc +1
  jmp -4
  acc +6
INPUT

def import_from_file(filename)
  file = File.open(filename)
  file.readlines.map(&:chomp)
end

def test_input
  TEST_INPUT.split("\n")
end

# @param program the instructions to be run
# @return a boolean indicating termination, and the accumulator value
def run_program(program)
  visited = []
  curr_loc = accum = 0

  until visited.include?(curr_loc) || curr_loc >= program.length
    visited << curr_loc
    instruction, amount = program[curr_loc].split(' ')
    case instruction
    when 'nop'
      curr_loc += 1
    when 'acc'
      curr_loc += 1
      accum += amount.to_i
    when 'jmp'
      curr_loc += amount.to_i
    else
      raise ArgumentError, 'invalid instruction found'
    end
  end
  { terminates: curr_loc >= program.length, accumulator: accum }
end

def part_one(program)
  run_program(program)[:accumulator]
end

def part_two(program)
  program.each_with_index do |line, index|
    instruction, amount = line.split(' ')
    next if instruction == 'acc'

    new_line = "#{instruction == 'nop' ? 'jmp' : 'nop'} #{amount}"
    new_prog = program.dup
    new_prog[index] = new_line
    result = run_program(new_prog)
    return result[:accumulator] if result[:terminates]
  end
end

puzz_input = import_from_file('puzz08_input.txt')

p part_one(test_input) # should be 5
p part_one(puzz_input)

p part_two(test_input) # should be 8
p part_two(puzz_input)
