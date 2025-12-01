import * as Console from "effect/Console"
import * as Effect from "effect/Effect"
import { solutions } from "./solutions/index.js"

export const runSolution = (day: number) =>
  Effect.gen(function*() {
    yield* Console.log(`Running solution for day ${day}...`)

    if (!(day in solutions)) {
      yield* Console.error(`Solution for day ${day} not found`)
      const dayStr = day.toString().padStart(2, "0")
      yield* Console.log(
        `Create a solution at src/solutions/day${dayStr}.ts and register it in src/solutions/index.ts`
      )
      return
    }
    const solution = solutions[day as keyof typeof solutions]

    yield* solution()
  })
