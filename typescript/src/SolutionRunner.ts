import * as FileSystem from "@effect/platform/FileSystem"
import * as Console from "effect/Console"
import * as Effect from "effect/Effect"
import * as Either from "effect/Either"
import { pipe } from "effect/Function"
import * as Stream from "effect/Stream"

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
      default: (input: Stream.Stream<string>) => Effect.Effect<void>
    }
    if (!module.default) {
      yield* Console.error(`Solution for day ${day} does not export a default function`)
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

    yield* module.default(inputStream).pipe(
      Effect.orDieWith((error) => new Error(`Error running solution: ${String(error)}`))
    )
  })
