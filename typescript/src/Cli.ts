import * as Args from "@effect/cli/Args"
import * as Command from "@effect/cli/Command"
import * as Console from "effect/Console"
import * as Effect from "effect/Effect"
import { runSolution } from "./SolutionRunner.js"

const day = Args.integer({ name: "day" }).pipe(
  Args.withDescription("The day number (1-25)")
)

const command = Command.make("aoc", { day }, ({ day }) =>
  Effect.gen(function*() {
    if (day < 1 || day > 25) {
      yield* Console.error(`Day must be between 1 and 25, got ${day}`)
      return
    }
    yield* runSolution(day)
  })).pipe(Command.withDescription("Run Advent of Code solution for a given day"))

export const run = Command.run(command, {
  name: "aoc",
  version: "0.0.0"
})
