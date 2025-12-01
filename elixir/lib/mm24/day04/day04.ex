defmodule MM24.Day04 do
  def parse_input(input) do
    lines =
      File.read!(input)
      |> String.split("\n", trim: true)
      # Add padding of 3 spaces to the beginning of each line.
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(fn row -> [" ", " ", " " | row] end)

    padding =
      lines
      |> hd()
      |> Enum.map(fn _ -> " " end)

    # Add 3 lines of padding to the top.
    [padding, padding, padding | lines]
  end

  @doc """
  Part 1

  ## Examples

      <!-- iex> MM24.Day04.part1("lib/mm24/day04/example.txt")
      18 -->

      <!-- iex> MM24.Day04.part1("lib/mm24/day04/input.txt")
      2514 -->

  """
  def part1(input) do
    parse_input(input)
    |> create_4x4_sliding_windows()
  end

  @xmas ["X", "M", "A", "S"]

  def count_window(window) do
    window
    |> Enum.map(fn row -> row == @xmas || Enum.reverse(row) == @xmas end)
    |> Enum.count(fn x -> x end)
  end

  def create_4x4_sliding_windows([
        [r1c1, r1c2, r1c3, r1c4 | r1rest] = _r1,
        [_r2c1, r2c2, r2c3, r2c4 | r2rest] = r2,
        [_r3c1, r3c2, r3c3, r3c4 | r3rest] = r3,
        [r4c1, r4c2, r4c3, r4c4 | r4rest] = r4 | rest
      ]) do
    window = [
      [r4c1, r4c2, r4c3, r4c4],
      [r1c4, r2c4, r3c4, r4c4],
      [r1c1, r2c2, r3c3, r4c4],
      [r4c1, r3c2, r2c3, r1c4]
    ]

    count_window(window) +
      create_4x4_sliding_windows([
        [r1c2, r1c3, r1c4 | r1rest],
        [r2c2, r2c3, r2c4 | r2rest],
        [r3c2, r3c3, r3c4 | r3rest],
        [r4c2, r4c3, r4c4 | r4rest]
      ]) +
      create_4x4_sliding_windows([r2, r3, r4 | rest])
  end

  def create_4x4_sliding_windows(_) do
    0
  end

  @doc """
  Part 2

  ## Examples

      iex> MM24.Day04.part2("lib/mm24/day04/example.txt")
      9

      iex> MM24.Day04.part2("lib/mm24/day04/input.txt")
      1888
  """
  def part2(input) do
    parse_input(input)
    |> check_with_3x3_window()
  end

  def check_with_3x3_window(input) do
    input
    # Make every row a sliding window of 3
    |> Enum.map(fn row -> Enum.chunk_every(row, 3, 1, :discard) end)
    # Make a sliding window of 3 sliding windows
    |> Enum.chunk_every(3, 1, :discard)
    # Zip the sliding windows together to create a 3x3 window
    |> Enum.flat_map(&Enum.zip/1)
    |> Enum.map(&check_xmas/1)
    |> Enum.count(fn x -> x === true end)
  end

  @mas ["M", "A", "S"]

  def check_xmas({
        [r1c1, _r1c2, r1c3],
        [_r2c1, r2c2, _r2c3],
        [r3c1, _r3c2, r3c3]
      }) do
    # Create diagonals
    [[r1c1, r2c2, r3c3], [r1c3, r2c2, r3c1]]
    # Check if all diagonals contain the MAS pattern
    |> Enum.map(fn row -> row == @mas || Enum.reverse(row) == @mas end)
    |> Enum.all?(fn x -> x === true end)
  end
end
