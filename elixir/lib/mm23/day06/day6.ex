defmodule MM23.Day6 do
  @doc """
  Part 1

  ## Examples

      iex> MM23.Day6.part1("lib/mm23/day06/example.txt")
      288

      iex> MM23.Day6.part1("lib/mm23/day06/input.txt")
      345015

  """
  def part1(input) do
    File.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      Regex.scan(~r/\d+/, line)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)
    end)
    |> List.zip()
    |> Enum.map(fn _race = {time, record} ->
      from =
        Enum.find(0..time, fn speed ->
          speed * (time - speed) > record
        end)

      till =
        Enum.find(time..0, fn speed ->
          speed * (time - speed) > record
        end)

      till - from + 1
    end)
    |> IO.inspect()
    |> Enum.reduce(1, fn n, res -> n * res end)
  end

  @doc """
  Part 2

  ## Examples

      iex> MM23.Day6.part2("lib/mm23/day06/example.txt")
      71503

      iex> MM23.Day6.part2("lib/mm23/day06/input.txt")
      42588603

  """
  def part2(input) do
    File.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      Regex.scan(~r/\d+/, line)
      |> Enum.reduce("", fn [n], acc -> acc <> n end)
      |> String.to_integer()
    end)
    |> IO.inspect()
    |> then(fn _race = [time, record] ->
      from =
        Enum.find(0..time, fn speed ->
          speed * (time - speed) > record
        end)

      till =
        Enum.find(time..0, fn speed ->
          speed * (time - speed) > record
        end)

      till - from + 1
    end)
  end
end
