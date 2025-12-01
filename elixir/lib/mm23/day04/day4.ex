defmodule MM23.Day4 do
  @doc """
  Part 1

  ## Examples

      iex> MM23.Day4.part1()
      26346

  """
  def part1 do
    # """
    # Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    # Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    # Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    # Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    # Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    # Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    # """
    File.read!("lib/mm23/day4/input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [_, game] = String.split(line, ":", trim: true)

      String.split(game, "|", trim: true)
      |> Enum.map(fn list ->
        Regex.scan(~r/\d+/, list)
        |> List.flatten()
        |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.map(&MapSet.new/1)
      |> then(fn [winning, have] ->
        MapSet.intersection(winning, have)
      end)
      |> MapSet.size()
      |> then(&(&1 - 1))
      |> then(&if &1 >= 0, do: 2 ** &1, else: 0)
    end)
    |> Enum.sum()
  end

  @doc """
  Part 2

  ## Examples

      iex> MM23.Day4.part2()
      8467762

  """
  def part2 do
    # """
    # Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    # Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    # Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    # Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    # Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    # Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    # """
    File.read!("lib/mm23/day4/input.txt")
    |> String.split("\n", trim: true)
    |> part2_do()
  end

  defp part2_do(lines), do: part2_do(lines, Enum.map(lines, fn _ -> 1 end))

  defp part2_do([], []), do: 0

  defp part2_do([line | tail], [copies | others]) do
    [_, game] = String.split(line, ":", trim: true)

    wins =
      String.split(game, "|", trim: true)
      |> Enum.map(fn list ->
        Regex.scan(~r/\d+/, list)
        |> List.flatten()
        |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.map(&MapSet.new/1)
      |> then(fn [winning, have] ->
        MapSet.intersection(winning, have)
      end)
      |> MapSet.size()

    more =
      Enum.take(others, wins)
      |> Enum.map(&(&1 + copies))

    others = more ++ Enum.drop(others, wins)

    copies + part2_do(tail, others)
  end
end
