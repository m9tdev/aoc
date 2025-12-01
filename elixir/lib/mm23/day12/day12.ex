defmodule MM23.Day12 do
  @doc """
  Part 1

  ## Examples

      # iex> MM23.Day12.part1("lib/mm23/day12/example.txt")
      # 21

      iex> MM23.Day12.part1("lib/mm23/day12/input.txt")
      0

  """
  def part1(input) do
    File.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [springs, groups_str] = String.split(line, " ")

      groups =
        String.split(groups_str, ",")
        |> IO.inspect(label: "groups")

      find_matches(springs, groups)
      |> IO.inspect(label: "res find_matches")
    end)
    |> IO.inspect(label: "res")
    |> Enum.sum()
  end

  defp find_matches(springs, []) do
    if String.contains?(springs, "#") do
      0
    else
      1
    end
    |> IO.inspect(label: "res #{springs}")
  end

  defp find_matches(springs, groups = [size | tail]) do
    IO.inspect({springs, groups}, label: "find_matches")

    r =
      Regex.compile!("(^|[.?])([#?]{#{size}})([.?]|$)")
      |> Regex.run(springs, return: :index)
      |> IO.inspect(label: "r")

    case r do
      [_, _, {match, _size}, {suffix, slen}] ->
        [{suffix + slen, tail}, {match + 1, groups}]
        |> Enum.map(fn {at, groups} ->
          {cut, springs} = String.split_at(springs, at)

          case String.last(cut) do
            "#" -> 0
            _ -> find_matches(springs, groups)
          end
        end)
        |> Enum.sum()

      _ ->
        0
    end
    |> IO.inspect(label: "res #{springs}")
  end

  @doc """
  Part 2

  ## Examples

      # iex> MM23.Day12.part2("lib/mm23/day12/example.txt")
      # 374
      #
      # iex> MM23.Day12.part2("lib/mm23/day12/input.txt")
      # 649862989626

  """
  def part2(input, _expand) do
    File.read!(input)
    |> String.split("\n", trim: true)
  end
end
