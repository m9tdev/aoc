defmodule MM24.Day05 do
  def parse_input(input) do
    [ordering, updates] =
      File.read!(input)
      |> String.split("\n\n", trim: true)
      |> Enum.map(fn part ->
        part
        |> String.split("\n", trim: true)
        |> Enum.map(&String.split(&1, ~r/[|,]/, trim: true))
      end)

    [ordering, updates]
  end

  @doc """
  Part 1

  ## Examples

      <!-- iex> MM24.Day05.part1("lib/mm24/day05/example.txt")
      143 -->

      <!-- iex> MM24.Day05.part1("lib/mm24/day05/input.txt")
      4135 -->
  """
  def part1(input) do
    [ordering, updates] = parse_input(input)

    lookup_table = create_ordering_lookup_table(ordering)

    updates
    |> Enum.filter(&is_ordered?(lookup_table, &1))
    |> Enum.map(&get_item_in_middle/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  def get_item_in_middle([middle]) do
    middle
  end

  def get_item_in_middle(update) do
    update
    |> List.delete_at(0)
    |> List.delete_at(-1)
    |> get_item_in_middle()
  end

  def is_ordered?(_lookup_table, [_]) do
    true
  end

  def is_ordered?(lookup_table, [head | tail]) do
    should_be_before_rest?(lookup_table, head, tail) and is_ordered?(lookup_table, tail)
  end

  def should_be_before_rest?(lookup_table, head, rest) do
    Enum.all?(rest, fn next ->
      is_wrong_order =
        lookup_table
        |> Map.get(next, %{})
        |> Map.get(head, false)

      !is_wrong_order
    end)
  end

  def create_ordering_lookup_table(ordering) do
    ordering
    |> Enum.reduce(%{}, fn [before, next], acc ->
      prev = Map.get(acc, before, %{})
      Map.put(acc, before, Map.put(prev, next, true))
    end)
    |> IO.inspect()
  end

  @doc """
  Part 2

  ## Examples

      iex> MM24.Day05.part2("lib/mm24/day05/example.txt")
      123

      iex> MM24.Day05.part2("lib/mm24/day05/input.txt")
      5285
  """
  def part2(input) do
    [ordering, updates] = parse_input(input)

    lookup_table = create_ordering_lookup_table(ordering)

    updates
    |> Enum.filter(fn update -> not is_ordered?(lookup_table, update) end)
    |> (fn updates ->
          IO.inspect(length(updates), label: "length")
          updates
        end).()
    |> Enum.with_index()
    |> Enum.map(fn {update, index} ->
      IO.inspect(index, label: "index")

      until_ordered(lookup_table, update)
      |> get_item_in_middle()
      |> String.to_integer()
    end)
    |> Enum.sum()
  end

  def until_ordered(lookup_table, update) do
    case is_ordered?(lookup_table, update) do
      true ->
        update

      false ->
        Enum.sort(update, fn a, b ->
          not (lookup_table
               |> Map.get(a, %{})
               |> Map.get(b, false))
        end)
    end
  end
end
