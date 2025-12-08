import * as Context from "effect/Context"
import type * as Effect from "effect/Effect"
import type * as Stream from "effect/Stream"

type SolutionPart =
  | ((input: Stream.Stream<string>) => Effect.Effect<number>)
  | ((input: Stream.Stream<string>, isExample: boolean) => Effect.Effect<number>)

export interface Solution {
  readonly part1: SolutionPart
  readonly part2: SolutionPart
}

export const Solution = Context.GenericTag<Solution>("Solution")
