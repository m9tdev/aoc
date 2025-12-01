defmodule MM24.Day02 do
  def parse_input(input) do
    File.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(fn report ->
      report
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  @doc """
  Part 1

  ## Examples

      iex> MM24.Day02.part1("lib/mm24/day02/example.txt")
      2

      <!-- iex> MM24.Day02.part1("lib/mm24/day02/input.txt")
      572 -->

  """
  def part1(input) do
    parse_input(input)
    |> Enum.map(&part1_check_is_safe/1)
    |> Enum.count(& &1)
  end

  def part1_check_is_safe([l1, l2 | _] = report) do
    diff = l1 - l2
    part1_check_is_safe(diff, report)
  end

  def part1_check_is_safe(_, [_]) do
    true
  end

  def part1_check_is_safe(prev_diff, [l1, l2 | next_report]) do
    diff = l1 - l2

    if same_sign_and_within_limit?(prev_diff, diff) do
      part1_check_is_safe(diff, [l2 | next_report])
    else
      false
    end
  end

  defp same_sign_and_within_limit?(prev_diff, diff) do
    abs(diff) <= 3 and abs(prev_diff) <= 3 and
      ((prev_diff < 0 and diff < 0) or (prev_diff > 0 and diff > 0))
  end

  @doc """
  Part 2

  ## Examples

      iex> MM24.Day02.part2("lib/mm24/day02/example.txt")
      4

      iex> MM24.Day02.part2("lib/mm24/day02/input.txt")
      612
  """
  def part2(input) do
    parse_input(input)
    |> Enum.map(&part2_check_is_safe/1)
    |> Enum.count(& &1)
  end

  def part2_check_is_safe(report) do
    part2_check_is_safe(0, [], report)
    |> IO.inspect()
  end

  def part2_check_is_safe(2, _, _) do
    false |> IO.inspect(label: "unsafe_count == 2")
  end

  def part2_check_is_safe(unsafe_count, prev, [l1, l2, l3 | tail] = report) do
    IO.inspect([unsafe_count, report], label: "check_is_safe", charlists: :as_lists)
    diff1 = l1 - l2
    diff2 = l2 - l3

    if same_sign_and_within_limit?(diff1, diff2) do
      part2_check_is_safe(unsafe_count, [l1 | prev], [l2, l3 | tail])
    else
      case prev do
        # If there is a previous value, we prepend it so the next check has at
        # least 3 values as tail can be empty.
        [p1 | prev_tail] ->
          part2_check_is_safe(unsafe_count + 1, prev_tail, [p1, l2, l3 | tail]) ||
            part2_check_is_safe(unsafe_count + 1, prev_tail, [p1, l1, l3 | tail]) ||
            part2_check_is_safe(unsafe_count + 1, prev_tail, [p1, l1, l2 | tail])

        # If there is no previous value, we assume tail is not empty.
        _ ->
          part2_check_is_safe(unsafe_count + 1, prev, [l2, l3 | tail]) ||
            part2_check_is_safe(unsafe_count + 1, prev, [l1, l3 | tail]) ||
            part2_check_is_safe(unsafe_count + 1, prev, [l1, l2 | tail])
      end
    end
  end

  def part2_check_is_safe(_, _, [_, _]) do
    true
  end
end
