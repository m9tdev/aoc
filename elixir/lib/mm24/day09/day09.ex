defmodule MM24.Day09 do
  def parse_input(input) do
    File.read!(input)
    |> String.split("\n", trim: true)
    |> List.first()
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  Part 1

  ## Examples

      iex> MM24.Day09.part1("lib/mm24/day09/example.txt")
      1928

      iex> MM24.Day09.part1("lib/mm24/day09/input.txt")
      6320029754031
  """
  def part1(input) do
    parse_input(input)
    |> Enum.with_index()
    |> Enum.map(fn {file, index} -> {file, div(index, 2)} end)
    |> checksum(0)

    # |> IO.inspect()
  end

  def checksum([{size, id}], index), do: file_checksum(size, id, index)

  def checksum([file, free | tail], index) do
    {size, id} = file
    {space, _} = free

    file_checksum = file_checksum(size, id, index)
    index = index + size

    %{checksum: checksum, index: index, blocks: blocks} = move_to_left(tail, space, index)

    file_checksum + checksum + checksum(blocks, index)
  end

  def move_to_left([file], space, index) do
    # IO.inspect({space, file, index}, label: "move to left")
    {size, id} = file

    cond do
      space < size ->
        # Take part of the file
        %{
          space: 0,
          checksum: file_checksum(space, id, index),
          index: index + space,
          blocks: [{size - space, id}]
        }

      # |> IO.inspect(label: "take a bit")

      space >= size ->
        # Take whole file
        %{
          space: space - size,
          checksum: file_checksum(size, id, index),
          index: index + size,
          blocks: []
        }

        # |> IO.inspect(label: "take whole")
    end
  end

  def move_to_left([head, free | tail] = blocks, space, index) do
    # IO.inspect({space, blocks, index}, label: "move to left")

    case move_to_left(tail, space, index) do
      # File fitted perfectly
      %{space: 0, blocks: []} = result ->
        # Strip the free space from the blocks
        %{result | blocks: [head]}

      # Filled up the space, but part of file left
      %{space: 0, blocks: blocks} = result ->
        # Keep left over part of file in the blocks
        %{result | blocks: [head, free | blocks]}

      # Space left, but file moved completely
      %{space: space, checksum: checksum, index: index} ->
        move_to_left([head], space, index)
        |> (&%{&1 | checksum: checksum + &1.checksum}).()

        # |> IO.inspect(label: "check this")
    end
  end

  def file_checksum(0, _id, _index), do: 0

  def file_checksum(size, id, index) do
    index * id + file_checksum(size - 1, id, index + 1)
  end

  @doc """
  Part 2

  ## Examples

      <!-- iex> MM24.Day09.part2("lib/mm24/day09/example.txt")
      34 -->

      <!-- iex> MM24.Day09.part2("lib/mm24/day09/input.txt")
      1233 -->
  """
  def part2(input) do
    parse_input(input)
  end
end
