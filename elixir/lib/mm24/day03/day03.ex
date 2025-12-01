defmodule MM24.Day03 do
  def parse_input(input) do
    File.read!(input)
  end

  @doc """
  Part 1

  ## Examples

      iex> MM24.Day03.part1("lib/mm24/day03/example.txt")
      161

      iex> MM24.Day03.part1("lib/mm24/day03/input.txt")
      174103751

  """
  def part1(input) do
    parse_input(input)
    |> part1_find_muls()
    |> Enum.map(fn {x, y} -> x * y end)
    |> Enum.sum()
  end

  def part1_find_muls(input) do
    # Find all mul(x,y) with regex
    Regex.scan(~r/mul\((?<x>\d+),(?<y>\d+)\)/, input)
    |> Enum.map(fn [_, x, y] ->
      {String.to_integer(x), String.to_integer(y)}
    end)
  end

  @doc """
  Part 2

  ## Examples

      iex> MM24.Day03.part2("lib/mm24/day03/example2.txt")
      48

      iex> MM24.Day03.part2("lib/mm24/day03/input.txt")
      100411201
  """
  def part2(input) do
    parse_input(input)
    |> part2_find_muls()
    |> Enum.at(1)
  end

  def part2_find_muls(input) do
    # Find all mul(x,y) and do() and don't() with regex
    Regex.scan(~r/mul\((?<x>\d+),(?<y>\d+)\)|do\(\)|don't\(\)/, input)
    |> Enum.reduce([true, 0], fn
      [_, x, y], [true, sum] ->
        [true, sum + String.to_integer(x) * String.to_integer(y)]

      [_, _, _], [false, sum] ->
        [false, sum]

      ["do()"], [_acc, sum] ->
        [true, sum]

      ["don't()"], [_acc, sum] ->
        [false, sum]
    end)
  end
end
