defmodule MM23.Day1 do
  @doc """
  Part 1

  ## Examples

      iex> MM23.Day1.part1()
      54708

  """
  def part1 do
    File.read!("lib/2023/day1/input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      ints =
        line
        |> String.graphemes()
        |> Enum.filter(&(&1 in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]))

      (List.first(ints) <> List.last(ints))
      |> String.to_integer()
    end)
    |> Enum.sum()
  end

  @doc """
  Day 1, Part 2

  ## Examples

      iex> MM23.Day1.part2()
      54087

  """
  def part2 do
    File.read!("lib/2023/day1/input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      ints =
        line
        # Convert written numbers to digits, while maintaining overlapping words like "eightwo" or "twone".
        |> String.replace("nine", "ni9ne")
        |> String.replace("eight", "ei8ght")
        |> String.replace("seven", "se7ven")
        |> String.replace("six", "si6x")
        |> String.replace("five", "fi5ve")
        |> String.replace("four", "fo4ur")
        |> String.replace("three", "th3ree")
        |> String.replace("two", "tw2o")
        |> String.replace("one", "on1e")
        |> String.graphemes()
        |> Enum.filter(&(&1 in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]))

      # IO.puts(line <> " -> " <> Enum.join(ints, ""))

      (List.first(ints) <> List.last(ints))
      |> String.to_integer()
    end)
    |> Enum.sum()
  end
end
