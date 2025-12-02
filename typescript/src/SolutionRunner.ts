import type { PlatformError } from "@effect/platform/Error"
import type * as FileSystem from "@effect/platform/FileSystem"
import * as Console from "effect/Console"
import * as Effect from "effect/Effect"
import * as Either from "effect/Either"

export const runSolution = (day: number) =>
  Effect.gen(function*() {
    yield* Console.log(`Running solution for day ${day}...`)

    const dayStr = day.toString().padStart(2, "0")
    // Bun can import .ts files directly, so we use .ts extension
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

    const module = moduleEither.right as { default: () => Effect.Effect<void, PlatformError, FileSystem.FileSystem> }
    if (!module.default) {
      yield* Console.error(`Solution for day ${day} does not export a default function`)
      return
    }

    yield* module.default().pipe(
      Effect.catchAll((error) =>
        Console.error(`Error running solution: ${error instanceof Error ? error.message : String(error)}`)
      )
    )
  })
