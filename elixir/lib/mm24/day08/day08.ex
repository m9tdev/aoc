defmodule MM24.Day08 do
  def parse_input(input) do
    File.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  @doc """
  Part 1

  ## Examples

      <!-- iex> MM24.Day08.part1("lib/mm24/day08/example.txt")
      14 -->

      <!-- iex> MM24.Day08.part1("lib/mm24/day08/input.txt")
      327 -->
  """
  def part1(input) do
    input_2d_array = parse_input(input)

    empty_map = empty_map_from_2d_array(input_2d_array)

    input_2d_array
    |> find_antenna_positions()
    |> Enum.flat_map(fn {_char, positions} ->
      part1_calculate_antinodes(positions)
    end)
    |> mark_positions(empty_map)
    |> map_to_2d_array()
    |> Enum.flat_map(fn row -> row end)
    |> Enum.count(fn char -> char == "#" end)
  end

  def mark_positions(positions, map) do
    positions
    |> Enum.reduce(map, fn {row, col}, acc ->
      case Map.get(acc, row) do
        nil ->
          acc

        row_map ->
          case Map.get(row_map, col) do
            nil -> acc
            _ -> Map.put(acc, row, Map.put(row_map, col, "#"))
          end
      end
    end)
  end

  def map_to_2d_array(map) do
    map
    |> Enum.map(fn {_row, row} ->
      Enum.map(row, fn {_col, char} -> char end)
    end)
  end

  def empty_map_from_2d_array(array) do
    array
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, row_i}, acc ->
      Map.put(
        acc,
        row_i,
        Enum.with_index(row)
        |> Enum.reduce(%{}, fn {_char, col_i}, acc ->
          Map.put(acc, col_i, ".")
        end)
      )
    end)
  end

  def part1_calculate_antinodes([_]), do: []

  def part1_calculate_antinodes([{row, col} | tail]) do
    Enum.flat_map(tail, fn {r, c} ->
      diff_row = r - row
      diff_col = c - col

      [
        {row - diff_row, col - diff_col},
        {r + diff_row, c + diff_col}
      ]
    end) ++ part1_calculate_antinodes(tail)
  end

  def find_antenna_positions(input) do
    input
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, row}, acc ->
      Enum.with_index(line)
      |> Enum.reduce(acc, fn {char, col}, acc ->
        if char != "." do
          prev = Map.get(acc, char, [])
          Map.put(acc, char, [{row, col} | prev])
        else
          acc
        end
      end)
    end)
  end

  @doc """
  Part 2

  ## Examples

      iex> MM24.Day08.part2("lib/mm24/day08/example.txt")
      34

      iex> MM24.Day08.part2("lib/mm24/day08/input.txt")
      1233
  """
  def part2(input) do
    input_2d_array = parse_input(input)

    row_count = length(input_2d_array)
    col_count = length(input_2d_array |> List.first())

    empty_map = empty_map_from_2d_array(input_2d_array)

    input_2d_array
    |> find_antenna_positions()
    |> Enum.flat_map(fn {_char, positions} ->
      part2_calculate_antinodes(positions, row_count, col_count)
    end)
    |> mark_positions(empty_map)
    |> map_to_2d_array()
    |> Enum.flat_map(fn row -> row end)
    |> Enum.count(fn char -> char == "#" end)
  end

  def part2_calculate_antinodes([_], _row_count, _col_count), do: []

  def part2_calculate_antinodes([{row, col} | tail], row_count, col_count) do
    Enum.flat_map(tail, fn {r, c} ->
      diff_row = r - row
      diff_col = c - col
      diff_next = {diff_row, diff_col}
      diff_prev = {diff_row * -1, diff_col * -1}

      extrapolate_antinodes({row, col}, diff_next, row_count, col_count) ++
        extrapolate_antinodes({row, col}, diff_prev, row_count, col_count)
    end) ++ part2_calculate_antinodes(tail, row_count, col_count)
  end

  def extrapolate_antinodes(antinode, diff, row_count, col_count) do
    {row, col} = antinode
    {diff_row, diff_col} = diff
    {row_next, col_next} = {row + diff_row, col + diff_col}

    if row_next < row_count and col_next < col_count and row_next >= 0 and col_next >= 0 do
      [antinode | extrapolate_antinodes({row_next, col_next}, diff, row_count, col_count)]
    else
      [antinode]
    end
  end
end
