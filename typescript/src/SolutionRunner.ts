import * as FileSystem from "@effect/platform/FileSystem"
import * as Console from "effect/Console"
import * as Effect from "effect/Effect"
import * as Either from "effect/Either"
import { pipe } from "effect/Function"
import type * as Layer from "effect/Layer"
import * as Stream from "effect/Stream"
import { Solution } from "./solutions/Solution.js"

export const runSolution = (day: number) =>
  Effect.gen(function*() {
    yield* Console.log(`Running solution for day ${day}...`)

    const dayStr = day.toString().padStart(2, "0")
    const modulePath = new URL(`./solutions/day${dayStr}.ts`, import.meta.url).href

    const moduleEither = yield* Effect.tryPromise({
      try: () => import(modulePath),
      catch: (error) => error as Error
    }).pipe(Effect.either)

    if (Either.isLeft(moduleEither)) {
      yield* Console.error(`Solution for day ${day} not found`)
      yield* Console.log(`Create a solution at src/solutions/day${dayStr}.ts`)
      return
    }

    const module = moduleEither.right as {
      default: Layer.Layer<Solution>
    }
    if (!module.default) {
      yield* Console.error(`Solution for day ${day} does not export a default layer`)
      return
    }

    // Read and process input file
    const fs = yield* FileSystem.FileSystem
    const year = new Date().getFullYear()
    const inputPath = `inputs/${year}-day${dayStr}.txt`

    const inputStream = pipe(
      fs.stream(inputPath),
      Stream.decodeText("utf-8"),
      Stream.splitLines,
      Stream.orDieWith((error) => new Error(`Failed to read input file: ${String(error)}`))
    )

    yield* pipe(
      Solution,
      Effect.flatMap((solution) =>
        Effect.gen(function*() {
          const resultPart1 = yield* solution.part1(inputStream)
          const resultPart2 = yield* solution.part2(inputStream)
          yield* Console.log("Part 1: ", resultPart1)
          yield* Console.log("Part 2: ", resultPart2)
        })
      ),
      Effect.provide(module.default),
      Effect.orDieWith((error) => new Error(`Error running solution: ${String(error)}`))
    )
  })
