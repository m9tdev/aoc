defmodule MM23.Day7 do
  @doc """
  Part 1

  ## Examples

      iex> MM23.Day7.part1("lib/mm23/day07/example.txt")
      6440

      iex> MM23.Day7.part1("lib/mm23/day07/input.txt")
      251287184

  """
  def part1(input) do
    File.read!(input)
    # Make cards sortable
    |> String.replace("A", "E")
    |> String.replace("K", "D")
    |> String.replace("Q", "C")
    |> String.replace("J", "B")
    |> String.replace("T", "A")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, " ")
      # Take first element (the hand)
      |> List.first()
      # Create char list
      |> String.graphemes()
      # Count occurences
      |> Enum.frequencies()
      # Map to count values
      |> Enum.map(fn {_, count} -> count end)
      # Sort descending
      |> Enum.sort(&>=/2)
      |> case do
        [5] -> 7
        [4, 1] -> 6
        [3, 2] -> 5
        [3, 1, 1] -> 4
        [2, 2, 1] -> 3
        [2, 1, 1, 1] -> 2
        [1, 1, 1, 1, 1] -> 1
      end
      |> then(fn type ->
        "#{type} #{line}"
      end)
    end)
    |> Enum.sort()
    # Iteratre with index
    |> Enum.with_index(1)
    |> Enum.map(fn {line, rank} ->
      String.split(line, " ")
      |> List.last()
      |> String.to_integer()
      |> then(fn bid ->
        bid * rank
      end)
    end)
    |> Enum.sum()
  end

  @doc """
  Part 2

  ## Examples

      iex> MM23.Day7.part2("lib/mm23/day07/example.txt")
      5905

      iex> MM23.Day7.part2("lib/mm23/day07/input.txt")
      250757288

  """
  def part2(input) do
    File.read!(input)
    # Make cards sortable
    |> String.replace("A", "E")
    |> String.replace("K", "D")
    |> String.replace("Q", "C")
    |> String.replace("J", "1")
    |> String.replace("T", "A")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      frequencies =
        String.split(line, " ")
        # Take first element (the hand)
        |> List.first()
        # Create char list
        |> String.graphemes()
        # Count occurences
        |> Enum.frequencies()

      {jokers, frequencies} =
        Map.pop(frequencies, "1", 0)

      counts =
        frequencies
        |> Enum.map(fn {_, count} -> count end)
        # Sort descending
        |> Enum.sort(&>=/2)

      case counts do
        [highest | tail] -> [highest + jokers | tail]
        [] -> [jokers]
      end
      |> case do
        [5] -> 7
        [4, 1] -> 6
        [3, 2] -> 5
        [3, 1, 1] -> 4
        [2, 2, 1] -> 3
        [2, 1, 1, 1] -> 2
        [1, 1, 1, 1, 1] -> 1
      end
      |> then(fn type ->
        "#{type} #{line}"
      end)
    end)
    |> Enum.sort()
    # Iteratre with index
    |> Enum.with_index(1)
    |> Enum.map(fn {line, rank} ->
      String.split(line, " ")
      |> List.last()
      |> String.to_integer()
      |> then(fn bid ->
        bid * rank
      end)
    end)
    |> Enum.sum()
  end
end
