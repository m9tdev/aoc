defmodule MM24.Day01 do
  @doc """
  Part 1

  ## Examples

      iex> MM24.Day1.part1("lib/mm24/day01/example.txt")
      11

      iex> MM24.Day1.part1("lib/mm24/day01/input.txt")
      2113135

  """
  def part1(input) do
    parse_input(input)
    # Order both lists from smallest to largest
    |> Enum.map(fn col ->
      col |> Enum.sort()
    end)
    # Calculate the distance between each pair
    |> Enum.zip_with(& &1)
    |> Enum.map(fn [left, right] ->
      abs(right - left)
    end)
    |> Enum.sum()
  end

  def parse_input(input) do
    File.read!(input)
    |> String.split("\n", trim: true)
    # Create two lists of numbers
    |> Enum.map(fn line ->
      line
      |> String.split("   ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.zip_with(& &1)
  end

  @doc """
  Part 2

  ## Examples

      iex> MM24.Day1.part2("lib/mm24/day01/example.txt")
      31

      iex> MM24.Day1.part2("lib/mm24/day01/input.txt")
      19097157
  """
  def part2(input) do
    [left, right] = parse_input(input)

    # Count the occurence of each value in 'right'
    frequencies = right |> Enum.frequencies()

    # For each value in 'left', find the number of occurences in 'right'
    left
    |> Enum.map(fn value ->
      # If the value is not in 'right', it contributes 0 to the sum
      value * (frequencies[value] || 0)
    end)
    |> Enum.sum()
  end
end
