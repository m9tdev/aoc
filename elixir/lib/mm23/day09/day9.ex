defmodule MM23.Day9 do
  @doc """
  Part 1

  ## Examples

      # iex> MM23.Day9.part1("lib/mm23/day09/example.txt")
      # 114

      # iex> MM23.Day9.part1("lib/mm23/day09/input.txt")
      # 1861775706

  """
  def part1(input) do
    File.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, " ")
      |> Enum.map(&String.to_integer/1)
      |> find_next()
    end)
    |> Enum.sum()
  end

  def find_next(seq) do
    if Enum.all?(seq, &(&1 == 0)) do
      0
    else
      Enum.chunk_every(seq, 2, 1, :discard)
      |> Enum.map(fn [a, b] -> b - a end)
      |> then(fn diffs -> List.last(seq) + find_next(diffs) end)
    end
  end

  @doc """
  Part 2

  ## Examples

      iex> MM23.Day9.part2("lib/mm23/day09/example.txt")
      2

      iex> MM23.Day9.part2("lib/mm23/day09/input.txt")
      1082

  """
  def part2(input) do
    File.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, " ")
      |> Enum.map(&String.to_integer/1)
      |> find_prev()
    end)
    |> Enum.sum()
  end

  def find_prev(seq) do
    if Enum.all?(seq, &(&1 == 0)) do
      0
    else
      Enum.chunk_every(seq, 2, 1, :discard)
      |> Enum.map(fn [a, b] -> b - a end)
      |> then(fn diffs -> List.first(seq) - find_prev(diffs) end)
    end
  end
end
