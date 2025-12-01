defmodule MM24.Day06 do
  def parse_input(input) do
    File.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  def find_start_position(map) do
    row = Enum.find_index(map, fn row -> Enum.any?(row, fn cell -> cell == "^" end) end)
    column = Enum.find_index(Enum.at(map, row), fn cell -> cell == "^" end)
    {row, column}
  end

  @doc """
  Part 1

  ## Examples

      <!-- iex> MM24.Day06.part1("lib/mm24/day06/example.txt")
      41 -->

      <!-- iex> MM24.Day06.part1("lib/mm24/day06/input.txt")
      5153 -->
  """
  def part1(input) do
    map = parse_input(input)

    {row, column} =
      find_start_position(map)

    part1_walk_map(map, ["^", ">", "v", "<"], {row, column})
    |> count_x()
  end

  def part1_walk_map(map, [curr | rest] = directions, {row, column}) do
    map =
      List.update_at(map, row, fn row ->
        List.update_at(row, column, fn _ -> "X" end)
      end)

    {new_row, new_column} =
      case curr do
        "^" -> {row - 1, column}
        "v" -> {row + 1, column}
        ">" -> {row, column + 1}
        "<" -> {row, column - 1}
      end

    if new_row < 0 or new_row >= length(map) or new_column < 0 or
         new_column >= length(Enum.at(map, 0)) do
      map
    else
      case Enum.at(Enum.at(map, new_row), new_column) do
        "#" ->
          part1_walk_map(map, rest ++ [curr], {row, column})

        _ ->
          part1_walk_map(map, directions, {new_row, new_column})
      end
    end
  end

  def count_x(map) do
    map
    |> List.flatten()
    |> Enum.count(fn cell -> cell == "X" end)
  end

  @doc """
  Part 2

  ## Examples

      iex> MM24.Day06.part2("lib/mm24/day06/example.txt")
      6

      iex> MM24.Day06.part2("lib/mm24/day06/input.txt")
      1963
  """
  def part2(input) do
    map = parse_input(input)

    {row, column} =
      find_start_position(map)

    part2_walk_map(map, ["^", ">", "v", "<"], {row, column}, false, 0)
  end

  def part2_walk_map(map, [curr | rest] = directions, {row, column}, added, step) do
    {new_row, new_column} =
      case curr do
        "^" -> {row - 1, column}
        "v" -> {row + 1, column}
        ">" -> {row, column + 1}
        "<" -> {row, column - 1}
      end

    new_map =
      List.update_at(map, new_row, fn row ->
        List.update_at(row, new_column, fn _ -> curr end)
      end)

    cond do
      new_row < 0 or new_row >= length(map) or new_column < 0 or
          new_column >= length(Enum.at(map, 0)) ->
        IO.inspect(step, label: "out")
        0

      Enum.at(Enum.at(map, new_row), new_column) == curr ->
        IO.inspect(step, label: "loop!!!")
        1

      Enum.at(Enum.at(map, new_row), new_column) == "#" ->
        part2_walk_map(map, rest ++ [curr], {row, column}, added, step)

      added ->
        part2_walk_map(new_map, directions, {new_row, new_column}, added, step)

      Enum.at(Enum.at(map, new_row), new_column) in ["^", ">", "v", "<"] ->
        part2_walk_map(new_map, directions, {new_row, new_column}, false, step + 1)

      true ->
        part2_walk_map(new_map, directions, {new_row, new_column}, false, step + 1) +
          part2_walk_map(
            map
            |> List.update_at(new_row, fn row ->
              List.update_at(row, new_column, fn _ -> "#" end)
            end),
            directions,
            {row, column},
            true,
            step
          )
    end
  end
end
