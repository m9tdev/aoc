defmodule MM23.Day11 do
  @doc """
  Part 1

  ## Examples

      iex> MM23.Day11.part1("lib/mm23/day11/example.txt")
      374

      iex> MM23.Day11.part1("lib/mm23/day11/input.txt")
      10289334

  """
  def part1(input) do
    File.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> expand_rows()
    |> transpose()
    |> expand_rows()
    |> transpose()
    |> find_galaxies()
    |> calculate_distances()
    |> Enum.sum()
  end

  def calculate_distances([]), do: []

  def calculate_distances(galaxies) do
    [{curr_y, curr_x} | tail] = galaxies

    distances =
      Enum.map(tail, fn {y, x} ->
        # Calculate manhattan distance
        abs(curr_y - y) + abs(curr_x - x)
      end)

    distances ++ calculate_distances(tail)
  end

  def find_galaxies(matrix) do
    # Each row with index as y
    Enum.with_index(matrix, fn row, y -> {y, row} end)
    |> Enum.reduce([], fn {y, row}, acc ->
      # Each cell with index as x
      Enum.with_index(row, fn cell, x -> {x, cell} end)
      |> Enum.reduce(acc, fn
        {x, "#"}, acc -> acc ++ [{y, x}]
        {_, "."}, acc -> acc
      end)
    end)
  end

  def expand_rows(matrix) do
    Enum.reduce(matrix, [], fn row, acc ->
      case Enum.all?(row, &(&1 == ".")) do
        true -> acc ++ [row, row]
        false -> acc ++ [row]
      end
    end)
  end

  def transpose(matrix) do
    Enum.zip(matrix) |> Enum.map(&Tuple.to_list/1)
  end

  @doc """
  Part 2

  ## Examples

      iex> MM23.Day11.part2("lib/mm23/day11/example.txt", 2)
      374

      iex> MM23.Day11.part2("lib/mm23/day11/example.txt", 10)
      1030

      iex> MM23.Day11.part2("lib/mm23/day11/example.txt", 100)
      8410

      iex> MM23.Day11.part2("lib/mm23/day11/input.txt", 1000000)
      649862989626

  """
  def part2(input, expand) do
    File.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> replace_rows()
    |> transpose()
    |> replace_rows()
    |> transpose()
    |> find_galaxies(expand)
    |> calculate_distances()
    |> Enum.sum()
  end

  def find_galaxies(matrix, expand) do
    {_, acc} =
      Enum.reduce(matrix, {0, []}, fn row, {y, acc} ->
        # Each cell with index as x
        {x, acc} =
          Enum.reduce(row, {0, acc}, fn
            ".", {x, acc} -> {x + 1, acc}
            "X", {x, acc} -> {x + expand, acc}
            "#", {x, acc} -> {x + 1, acc ++ [{y, x}]}
          end)

        if x == expand * Enum.count(row) do
          {y + expand, acc}
        else
          {y + 1, acc}
        end
      end)

    acc
  end

  def replace_rows(matrix) do
    Enum.reduce(matrix, [], fn row, acc ->
      case Enum.all?(row, &(&1 != "#")) do
        true -> acc ++ [Enum.map(row, fn _ -> "X" end)]
        false -> acc ++ [row]
      end
    end)
  end
end
