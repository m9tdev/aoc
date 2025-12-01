import type * as Effect from "effect/Effect"
import day01 from "./day01.js"

export const solutions = new Map<number, () => Effect.Effect<void>>([
  [1, day01]
])
