import * as Args from "@effect/cli/Args"
import * as Command from "@effect/cli/Command"
import * as Options from "@effect/cli/Options"
import * as Console from "effect/Console"
import * as Effect from "effect/Effect"
import { downloadInput } from "./InputDownloader.js"
import { runSolution } from "./SolutionRunner.js"

const getCurrentDay = (): number => {
  const now = new Date()
  // If it's December, use the current day (1-25), otherwise default to 1
  if (now.getMonth() === 11) {
    // December is month 11 (0-indexed)
    return Math.min(now.getDate(), 25)
  }
  return 1
}

const day = Options.integer("day").pipe(
  Options.withDefault(getCurrentDay()),
  Options.withDescription("The day number (1-25, defaults to current day in December or 1)")
)

const year = Args.integer({ name: "year" }).pipe(
  Args.optional,
  Args.withDescription("The year (defaults to current year)")
)

const example = Options.boolean("example", { ifPresent: true, aliases: ["e"] }).pipe(
  Options.withDescription("Use example input instead of real input (defaults to false)")
)

// Run command
const runCommand = Command.make("run", { day, example }, ({ day, example: useExample }) =>
  Effect.gen(function*() {
    if (day < 1 || day > 25) {
      yield* Console.error(`Day must be between 1 and 25, got ${day}`)
      return
    }
    yield* runSolution(day, useExample)
  })).pipe(Command.withDescription("Run Advent of Code solution for a given day"))

// Download command
const downloadCommand = Command.make("download", { day, year }, ({ day, year: yearArg }) =>
  Effect.gen(function*() {
    if (day < 1 || day > 25) {
      yield* Console.error(`Day must be between 1 and 25, got ${day}`)
      return
    }
    const yearValue = yearArg._tag === "Some" ? yearArg.value : new Date().getFullYear()
    yield* downloadInput(day, yearValue)
  })).pipe(Command.withDescription("Download input for a given day (defaults to current day)"))

// Main command with subcommands
// Both run and download are subcommands, so:
// - `aoc run` runs the solution for the current day (or `aoc run --day 1` for a specific day)
// - `aoc download` downloads input for the current day (or `aoc download --day 1` for a specific day)
const command = Command.make("aoc").pipe(
  Command.withDescription("Advent of Code CLI"),
  Command.withSubcommands([runCommand, downloadCommand])
)

export const run = Command.run(command, {
  name: "aoc",
  version: "0.0.0"
})
