import type * as FileSystem from "@effect/platform/FileSystem"
import * as Path from "@effect/platform/Path"
import * as PlatformConfigProvider from "@effect/platform/PlatformConfigProvider"
import * as Config from "effect/Config"
import * as ConfigError from "effect/ConfigError"
import * as Effect from "effect/Effect"
import { pipe } from "effect/Function"

/**
 * Loads AOC_SESSION from environment variables or .env file using Effect's Config system.
 * Checks process.env first, then falls back to .env file if available.
 */
export const getAocSession = (): Effect.Effect<string | undefined, never, FileSystem.FileSystem | Path.Path> =>
  Effect.gen(function*() {
    const path = yield* Path.Path

    // Try to read from .env file using Effect's built-in dotenv support
    const envPath = path.join(process.cwd(), ".env")
    const sessionCookie = yield* pipe(
      Config.string("AOC_SESSION"),
      Effect.provide(PlatformConfigProvider.layerDotEnvAdd(envPath)),
      Effect.catchIf(
        (error) => ConfigError.isMissingData(error) || ConfigError.isSourceUnavailable(error),
        () => Effect.succeed(undefined)
      ),
      Effect.catchAll(() => Effect.succeed(undefined))
    )

    return sessionCookie
  })
