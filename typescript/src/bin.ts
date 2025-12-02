#!/usr/bin/env bun

import * as BunContext from "@effect/platform-bun/BunContext"
import * as BunRuntime from "@effect/platform-bun/BunRuntime"
import * as FetchHttpClient from "@effect/platform/FetchHttpClient"
import * as Effect from "effect/Effect"
import * as Layer from "effect/Layer"
import { run } from "./Cli.js"

run(process.argv).pipe(
  Effect.provide(Layer.merge(BunContext.layer, FetchHttpClient.layer)),
  BunRuntime.runMain({ disableErrorReporting: true })
)
