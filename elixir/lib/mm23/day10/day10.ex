defmodule MM23.Day10 do
  @doc """
  Part 1

  ## Examples

      iex> MM23.Day10.part1("lib/mm23/day10/example.txt")
      4

      iex> MM23.Day10.part1("lib/mm23/day10/example2.txt")
      8

      iex> MM23.Day10.part1("lib/mm23/day10/input.txt")
      6856

  """
  def part1(input) do
    lines =
      File.read!(input)
      |> String.split("\n", trim: true)

    start =
      Enum.reduce_while(lines, {0, 0}, fn line, {y, _} ->
        # Get the index of the first "S" character
        case String.split(line, "S") do
          [left, _] -> {:halt, {y, String.length(left)}}
          [_] -> {:cont, {y + 1, 0}}
        end
      end)

    # Find the pipes connected to the start
    [:north, :east, :south, :west]
    |> Enum.map(&move(lines, start, &1))
    |> Enum.filter(fn
      {_, :disconnected} -> false
      _ -> true
    end)
    |> then(&match(1, lines, &1))
  end

  def match(acc, lines, locs) do
    case locs do
      # Ended up at the furthest point.
      [{l, _}, {l, _}] ->
        acc

      _ ->
        Enum.map(locs, fn {loc, dir} -> move(lines, loc, dir) end)
        |> then(&match(acc + 1, lines, &1))
    end
  end

  def move(lines, _loc = {y, x}, dir) do
    next_loc =
      {y, x} =
      case dir do
        :north -> {y - 1, x}
        :east -> {y, x + 1}
        :south -> {y + 1, x}
        :west -> {y, x - 1}
      end

    from_dir = opposite(dir)

    {from_dir_connected, connections} =
      Enum.at(lines, y)
      |> String.at(x)
      |> connections()
      |> Map.pop(from_dir)

    case from_dir_connected do
      false ->
        {next_loc, :disconnected}

      true ->
        next_dir =
          connections
          |> Map.reject(fn {_, v} -> not v end)
          |> Map.keys()
          |> List.first()

        {next_loc, next_dir}
    end
  end

  def opposite(dir) do
    case dir do
      :north -> :south
      :east -> :west
      :south -> :north
      :west -> :east
    end
  end

  def connections(char) do
    case char do
      "|" -> %{:north => true, :east => false, :south => true, :west => false}
      "-" -> %{:north => false, :east => true, :south => false, :west => true}
      "L" -> %{:north => true, :east => true, :south => false, :west => false}
      "J" -> %{:north => true, :east => false, :south => false, :west => true}
      "7" -> %{:north => false, :east => false, :south => true, :west => true}
      "F" -> %{:north => false, :east => true, :south => true, :west => false}
      "." -> %{:north => false, :east => false, :south => false, :west => false}
    end
  end

  @doc """
  Part 2

  ## Examples

      # iex> MM23.Day10.part2("lib/mm23/day10/example.txt")
      # 2

      # iex> MM23.Day10.part2("lib/mm23/day10/input.txt")
      # 1082

  """
  def part2(input) do
    File.read!(input)
  end
end
