defmodule MM22.Day1 do
  @moduledoc """
  Documentation for `Day1`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> MM22.Day1.part1()
      205805

  """
  def part1 do
    File.read!("lib/mm22/day1/input.txt")
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn elf_inventory ->
      elf_inventory
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()
    end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end
end
