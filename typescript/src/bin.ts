#!/usr/bin/env node

import * as NodeContext from "@effect/platform-node/NodeContext"
import * as NodeHttpClient from "@effect/platform-node/NodeHttpClient"
import * as NodeRuntime from "@effect/platform-node/NodeRuntime"
import * as Effect from "effect/Effect"
import * as Layer from "effect/Layer"
import { run } from "./Cli.js"

run(process.argv).pipe(
  Effect.provide(Layer.merge(NodeContext.layer, NodeHttpClient.layer)),
  NodeRuntime.runMain({ disableErrorReporting: true })
)
