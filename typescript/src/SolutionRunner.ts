import * as Prompt from "@effect/cli/Prompt"
import * as FileSystem from "@effect/platform/FileSystem"
import * as Path from "@effect/platform/Path"
import * as Console from "effect/Console"
import * as Effect from "effect/Effect"
import * as Either from "effect/Either"
import { pipe } from "effect/Function"
import type * as Layer from "effect/Layer"
import * as Stream from "effect/Stream"
import { downloadInput } from "./InputDownloader.js"
import { Solution } from "./solutions/Solution.js"

export const runSolution = (day: number, useExample: boolean = false) =>
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
    const path = yield* Path.Path
    const year = new Date().getFullYear()
    const inputPath = `inputs/${year}-day${dayStr}${useExample ? "-example" : ""}.txt`
    const fullInputPath = path.join(process.cwd(), inputPath)

    // Check if input file exists, and ask to download if it doesn't (only for real inputs, not examples)
    if (!useExample) {
      const fileExists = yield* fs.exists(fullInputPath)
      if (!fileExists) {
        yield* Console.log(`Input file not found: ${inputPath}`)
        const shouldDownload = yield* Prompt.toggle({
          message: `Download input for day ${day}?`,
          initial: true,
          active: "yes",
          inactive: "no"
        })
        if (shouldDownload) {
          yield* downloadInput(day, year)
        } else {
          yield* Console.log("Skipping download. Run 'aoc download' to download the input manually.")
          return
        }
      }
    } else {
      // For example inputs, just check if they exist
      const fileExists = yield* fs.exists(fullInputPath)
      if (!fileExists) {
        yield* Console.error(`Example input file not found: ${inputPath}`)
        yield* Console.log(`Please create the example input file at ${inputPath}`)
        return
      }
    }

    const inputStream = pipe(
      fs.stream(fullInputPath),
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
