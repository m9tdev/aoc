defmodule MM23.Day13 do
  @doc """
  Part 1

  ## Examples

      iex> MM23.Day13.part1("lib/mm23/day13/example.txt")
      405

      iex> MM23.Day13.part1("lib/mm23/day13/input.txt")
      32035

  """
  def part1(input) do
    File.read!(input)
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn pattern ->
      pattern
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)
      |> then(fn matrix ->
        res =
          transpose(matrix)
          |> find_reflection()

        if res > 0 do
          res
        else
          100 * find_reflection(matrix)
        end
      end)
    end)
    |> Enum.sum()
  end

  defp find_reflection(matrix) do
    [row1 | rows] = matrix
    find_reflection([row1], rows)
  end

  defp find_reflection(_, []), do: 0

  defp find_reflection(left_rev, right) do
    case equal(left_rev, right) do
      true ->
        length(left_rev)

      false ->
        [rhead | rtail] = right
        find_reflection([rhead | left_rev], rtail)
    end
  end

  defp equal(list1, list2) do
    case {list1, list2} do
      {[h], [h | _]} -> true
      {[h | _], [h]} -> true
      {[h | t1], [h | t2]} -> equal(t1, t2)
      _ -> false
    end
  end

  defp transpose(matrix) do
    Enum.zip(matrix) |> Enum.map(&Tuple.to_list/1)
  end

  @doc """
  Part 2

  ## Examples

      # iex> MM23.Day13.part2("lib/mm23/day13/example.txt")
      # 374
      #
      # iex> MM23.Day13.part2("lib/mm23/day13/input.txt")
      # 649862989626

  """
  def part2(input, _expand) do
    File.read!(input)
    |> String.split("\n", trim: true)
  end
end
