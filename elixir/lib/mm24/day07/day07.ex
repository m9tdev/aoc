defmodule MM24.Day07 do
  def parse_input(input) do
    File.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(fn equation ->
      [result, numbers] = String.split(equation, ": ", trim: true)

      {
        String.to_integer(result),
        String.split(numbers, " ", trim: true)
        |> Enum.map(&String.to_integer/1)
      }
    end)
    |> IO.inspect()
  end

  @doc """
  Part 1

  ## Examples

      <!-- iex> MM24.Day07.part1("lib/mm24/day07/example.txt")
      3749 -->

      <!-- iex> MM24.Day07.part1("lib/mm24/day07/input.txt")
      4135 -->
  """
  def part1(input) do
    parse_input(input)
    |> Enum.map(fn {result, [head | tail]} ->
      part1_solve_equation(head, {result, tail})
    end)
    |> Enum.sum()
  end

  def part1_solve_equation(sum, {result, [head | tail]}) do
    IO.inspect({sum, head})

    add = part1_solve_equation(sum + head, {result, tail})

    case add do
      0 -> part1_solve_equation(sum * head, {result, tail})
      _ -> add
    end
    |> IO.inspect()
  end

  def part1_solve_equation(sum, {result, []}) do
    case sum == result do
      true -> sum
      false -> 0
    end
  end

  @doc """
  Part 2

  ## Examples

      <!-- iex> MM24.Day07.part2("lib/mm24/day07/example.txt")
      11387 -->

      iex> MM24.Day07.part2("lib/mm24/day07/input.txt")
      97902809384118
  """
  def part2(input) do
    parse_input(input)
    |> Enum.map(fn {result, [head | tail]} ->
      part2_solve_equation(head, {result, tail})
    end)
    |> Enum.sum()
  end

  def part2_solve_equation(sum, {result, [head | tail]}) do
    operations =
      [
        sum + head,
        sum * head,
        String.to_integer(Integer.to_string(sum) <> Integer.to_string(head))
      ]

    Enum.reduce_while(operations, 0, fn operation, _acc ->
      res = part2_solve_equation(operation, {result, tail})

      case res do
        0 -> {:cont, 0}
        _ -> {:halt, res}
      end
    end)
  end

  def part2_solve_equation(sum, {result, []}) do
    case sum == result do
      true -> sum
      false -> 0
    end
  end
end
