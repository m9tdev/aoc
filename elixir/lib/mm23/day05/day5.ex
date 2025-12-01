defmodule MM23.Day5 do
  @doc """
  Part 1

  ## Examples

      iex> MM23.Day5.part1("lib/mm23/day05/example.txt")
      35

      iex> MM23.Day5.part1("lib/mm23/day05/input.txt")
      282277027

  """
  def part1(input) do
    File.read!(input)
    |> String.split("\n\n", trim: true)
    |> then(fn [seeds_str | raw_mappings] ->
      mappings =
        Enum.map(raw_mappings, fn raw_map ->
          String.split(raw_map, "\n", trim: true)
          |> Enum.drop(1)
          |> Enum.map(fn row ->
            Regex.scan(~r/\d+/, row)
            |> List.flatten()
            |> Enum.map(&String.to_integer/1)
          end)
        end)

      Regex.scan(~r/\d+/, seeds_str)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)
      |> Enum.map(fn n ->
        Enum.reduce(mappings, n, fn map, n ->
          Enum.reduce_while(map, n, fn [dest, src, len], n ->
            if n >= src and n < src + len do
              {:halt, n + (dest - src)}
            else
              {:cont, n}
            end
          end)
        end)
      end)
      |> Enum.min()
    end)
  end

  @doc """
  Part 2

  ## Examples

      iex> MM23.Day5.part2("lib/mm23/day05/example.txt")
      46

      iex> MM23.Day5.part2("lib/mm23/day05/input.txt")
      11554135

  """
  def part2(input) do
    File.read!(input)
    |> String.split("\n\n", trim: true)
    |> then(fn [seeds_str | raw_mappings] ->
      # Convert [from, len, from, len, ...] to [[from, len], [from, len], ...]
      seed_ranges =
        Regex.scan(~r/\d+/, seeds_str)
        |> List.flatten()
        |> Enum.map(&String.to_integer/1)
        |> Enum.chunk_every(2)

      # List of mappings
      mappings =
        Enum.map(raw_mappings, fn raw_map ->
          String.split(raw_map, "\n", trim: true)
          |> Enum.drop(1)
          |> Enum.map(fn row ->
            Regex.scan(~r/\d+/, row)
            |> List.flatten()
            |> Enum.map(&String.to_integer/1)
          end)
        end)

      # Apply each map to all seed ranges
      Enum.reduce(mappings, seed_ranges, &apply_map/2)
      |> Enum.map(fn [from, _] -> from end)
      |> Enum.min()
    end)
  end

  def apply_map(map, seed_ranges) do
    # Initially all seed ranges are unhandled
    acc = %{queue: seed_ranges, handled: []}

    # Apply each map_row to the seed ranges
    Enum.reduce(map, acc, fn map_row, acc ->
      %{queue: queue, handled: handled} = acc

      # Skip ranges for this map_row if already
      # handled within this map
      next_acc = %{queue: [], handled: handled}

      # Try to map unhanded ranges
      Enum.reduce(queue, next_acc, fn range, next_acc ->
        res = apply_map_row(range, map_row)

        %{
          # Collect unhandled ranges for the next map_row
          queue: next_acc.queue ++ res.queue,
          # Handled changes are not queued for this map anymore
          handled: next_acc.handled ++ res.handled
        }
      end)
    end)
    |> then(fn %{queue: queue, handled: handled} ->
      # Combine handled and unhandled ranges for the next map
      handled ++ queue
    end)
  end

  def apply_map_row(range, map_row) do
    [from, len] = range
    [dest, src, mlen] = map_row
    [range_start, range_end] = [from, from + len - 1]
    [src_start, src_end] = [src, src + mlen - 1]
    delta = dest - src

    cond do
      # Range is before map
      range_end < src_start ->
        %{
          queue: [range],
          handled: []
        }

      # Range is after map
      src_end < range_start ->
        %{
          queue: [range],
          handled: []
        }

      # Range is within map
      src_start <= range_start and range_end <= src_end ->
        %{
          queue: [],
          handled: [[range_start + delta, len]]
        }

      # Range overlaps start of map
      range_start < src_start and range_end <= src_end ->
        len_before = src_start - range_start
        len_mapped = len - len_before

        %{
          queue: [[range_start, len_before]],
          handled: [[dest, len_mapped]]
        }

      # Range overlaps end of map
      src_start <= range_start and src_end < range_end ->
        len_after = range_end - src_end
        len_mapped = len - len_after

        %{
          queue: [[src_end + 1, len_after]],
          handled: [[range_start + delta, len_mapped]]
        }

      # Range overlaps both ends of map
      range_start < src_start and src_end < range_end ->
        len_before = src_start - range_start
        len_after = range_end - src_end
        len_mapped = len - len_before - len_after

        %{
          queue: [[range_start, len_before], [src_end + 1, len_after]],
          handled: [[dest, len_mapped]]
        }

      true ->
        [range]
    end
  end
end
