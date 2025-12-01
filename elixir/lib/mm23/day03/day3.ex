defmodule MM23.Day3 do
  @doc """
  Part 1

  ## Examples

      iex> MM23.Day3.part1_2()
      550064

  """
  def part1_2 do
    _ = """
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
    """

    File.read!("lib/mm23/day3/input.txt")
    |> String.split("\n", trim: true)
    # Add dots around the input to not check for out of bounds.
    |> pad_input()
    # Sliding window of 3 lines.
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(fn [prev, curr, next] ->
      Regex.scan(~r/\d+/, curr, return: :index)
      # Loop over all the (indices of) numbers in the current line.
      |> Enum.map(fn [{i, len}] ->
        # Check the number's surroundings.
        Enum.any?([prev, curr, next], fn line ->
          String.slice(line, i - 1, len + 2)
          # For anything other than digits or dots.
          |> String.match?(~r/[^\d\.]/)
        end)
        |> if(do: String.slice(curr, i, len), else: "0")
        |> String.to_integer()
      end)
      |> Enum.sum()
    end)
    |> Enum.sum()
  end

  @doc """
  Part 2

  ## Examples

      iex> MM23.Day3.part2()
      85010461

  """
  def part2 do
    _ = """
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
    """

    File.read!("lib/mm23/day3/input.txt")
    |> String.split("\n", trim: true)
    # Add dots around the input to not check for out of bounds.
    |> pad_input()
    # Sliding window of 3 lines.
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(fn [prev, curr, next] ->
      Regex.scan(~r/\*/, curr, return: :index)
      # Loop over all the (indices of) cogs in the current line.
      |> Enum.map(fn [{i, _}] ->
        Enum.map([prev, curr, next], fn line ->
          # Find the numbers surrounding the cog.
          Regex.scan(~r/\d+/, line, return: :index)
          |> Enum.filter(fn [{ii, ll}] ->
            ii - 1 <= i and i <= ii + ll
          end)
          # Map the indices to numbers.
          |> Enum.map(fn [{ii, ll}] ->
            String.slice(line, ii, ll)
            |> String.to_integer()
          end)
        end)
        |> List.flatten()
        # Multiply the numbers only if there are two.
        |> case do
          [a, b] -> a * b
          _ -> 0
        end
      end)
      |> Enum.sum()
    end)
    |> Enum.sum()
  end

  defp pad_input(input) do
    input
    |> then(fn lines ->
      width = length(lines)
      extra = String.duplicate(".", width)
      [extra] ++ lines ++ [extra]
    end)
    |> Enum.map(fn line -> "." <> line <> "." end)
  end
end
