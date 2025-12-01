defmodule MM23.Day2 do
  @doc """
  Part 1

  ## Examples

      iex> MM23.Day2.part1()
      2406

  """
  def part1 do
    max_cubes = %{
      red: 12,
      green: 13,
      blue: 14
    }

    File.read!("lib/mm23/day2/input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn game ->
      # Check if any game has a set with a cube over the max.
      game
      |> String.replace(~r/Game \d+: /, "")
      |> String.split("; ", trim: true)
      |> Enum.any?(fn set ->
        # Check if any set has a cube over the max.
        set
        |> String.split(", ", trim: true)
        |> Enum.any?(fn cube ->
          # Check if any cube is over the max.
          cube
          |> String.split(" ", trim: true)
          |> (fn [count, color] ->
                count = String.to_integer(count)
                key = String.to_atom(color)
                Map.has_key?(max_cubes, key) and count > max_cubes[key]
              end).()
        end)
      end)
      |> (fn
            true ->
              0

            false ->
              Regex.run(~r/Game (\d+):/, game)
              |> List.last()
              |> String.to_integer()
          end).()
    end)
    |> Enum.sum()
  end

  @doc """
  Part 2

  ## Examples

      iex> MM23.Day2.part2()
      78375

  """
  def part2 do
    File.read!("lib/mm23/day2/input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn game ->
      # check for each game the miniumum number of cubes needed for each color.
      game
      |> String.replace(~r/Game \d+: /, "")
      |> String.split("; ", trim: true)
      |> Enum.reduce(%{}, fn set, acc ->
        # accumulate the minimum number of cubes needed for each color.
        set
        |> String.split(", ", trim: true)
        # Check if any cube is over the max.
        |> Enum.reduce(acc, fn cube, acc ->
          [count, color] =
            cube
            |> String.split(" ", trim: true)

          count = String.to_integer(count)
          key = String.to_atom(color)
          max = Map.get(acc, key, 0)

          Map.put(acc, key, max(count, max))
        end)
      end)
      # Multiply the values for each color entry.
      |> Enum.reduce(1, fn {_, value}, acc ->
        value * acc
      end)
    end)
    |> Enum.sum()
  end
end
