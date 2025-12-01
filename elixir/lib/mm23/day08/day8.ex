defmodule MM23.Day8 do
  @doc """
  Part 1

  ## Examples

      iex> MM23.Day8.part1("lib/mm23/day08/example.txt")
      2

      iex> MM23.Day8.part1("lib/mm23/day08/example2.txt")
      6

      iex> MM23.Day8.part1("lib/mm23/day08/input.txt")
      21251

  """
  def part1(input) do
    [instructions | nodes_str] =
      File.read!(input)
      |> String.split("\n", trim: true)

    nodes_str
    |> Enum.map(&Regex.scan(~r/[A-Z]+/, &1))
    |> Enum.map(&List.flatten(&1))
    |> Enum.reduce(%{}, fn [from, left, right], map -> Map.put(map, from, [left, right]) end)
    |> find("AAA", instructions)
  end

  # Ends with "Z"
  def find(_, _curr = <<_a, _b, ?Z>>, _) do
    0
  end

  def find(nodes, curr, instructions) do
    {curr, instructions} = next(nodes, curr, instructions)
    1 + find(nodes, curr, instructions)
  end

  def next(nodes, curr, instructions) do
    [left, right] = Map.get(nodes, curr)

    case instructions do
      "L" <> instructions -> {left, instructions <> "L"}
      "R" <> instructions -> {right, instructions <> "R"}
    end
  end

  @doc """
  Part 2

  ## Examples

      iex> MM23.Day8.part2("lib/mm23/day08/example.txt")
      2

      iex> MM23.Day8.part2("lib/mm23/day08/example2.txt")
      6

      iex> MM23.Day8.part2("lib/mm23/day08/example3.txt")
      6

      iex> MM23.Day8.part2("lib/mm23/day08/input.txt")
      11678319315857

  """
  def part2(input) do
    [instructions | nodes_str] =
      File.read!(input)
      |> String.split("\n", trim: true)

    nodes =
      nodes_str
      |> Enum.map(&Regex.scan(~r/[1-9A-Z]+/, &1))
      |> Enum.map(&List.flatten(&1))
      |> Enum.reduce(%{}, fn [key, l, r], map -> Map.put(map, key, [l, r]) end)

    start_nodes =
      nodes
      |> Map.keys()
      |> Enum.filter(fn _key = <<_, _, c>> -> c == ?A end)

    loop_lengths =
      Enum.map(start_nodes, fn start_node ->
        find(nodes, start_node, instructions)
      end)

    lcm(loop_lengths)
  end

  # Greatest common divisor
  def gcd(a, 0), do: a
  def gcd(a, b), do: gcd(b, rem(a, b))

  # Least common multiple
  def lcm(a, b), do: div(abs(a * b), gcd(a, b))
  def lcm(list) when is_list(list), do: Enum.reduce(list, 1, &lcm/2)
end
