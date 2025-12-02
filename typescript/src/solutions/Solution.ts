import * as Context from "effect/Context"
import type * as Effect from "effect/Effect"
import type * as Stream from "effect/Stream"

export interface Solution {
  readonly part1: (input: Stream.Stream<string>) => Effect.Effect<number>
  readonly part2: (input: Stream.Stream<string>) => Effect.Effect<number>
}

export const Solution = Context.GenericTag<Solution>("Solution")
