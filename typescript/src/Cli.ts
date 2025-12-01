import * as Args from "@effect/cli/Args"
import * as Command from "@effect/cli/Command"
import * as Console from "effect/Console"
import * as Effect from "effect/Effect"
import { downloadInput } from "./InputDownloader.js"
import { runSolution } from "./SolutionRunner.js"

const day = Args.integer({ name: "day" }).pipe(
  Args.withDescription("The day number (1-25)")
)

const year = Args.integer({ name: "year" }).pipe(
  Args.optional,
  Args.withDescription("The year (defaults to current year)")
)

// Run command
const runCommand = Command.make("run", { day }, ({ day }) =>
  Effect.gen(function*() {
    if (day < 1 || day > 25) {
      yield* Console.error(`Day must be between 1 and 25, got ${day}`)
      return
    }
    yield* runSolution(day)
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
  })).pipe(Command.withDescription("Download input for a given day"))

// Main command with subcommands
// Both run and download are subcommands, so:
// - `aoc run 1` runs the solution for day 1
// - `aoc download 1` downloads input for day 1
const command = Command.make("aoc").pipe(
  Command.withDescription("Advent of Code CLI"),
  Command.withSubcommands([runCommand, downloadCommand])
)

export const run = Command.run(command, {
  name: "aoc",
  version: "0.0.0"
})
