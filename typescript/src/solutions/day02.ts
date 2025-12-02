import type * as Effect from "effect/Effect"
import { pipe } from "effect/Function"
import * as Layer from "effect/Layer"
import * as Schema from "effect/Schema"
import * as Stream from "effect/Stream"
import { Solution } from "./Solution.js"

const rangeSchema = Schema.TemplateLiteralParser(
  Schema.Int,
  "-",
  Schema.Int
)

const parseRanges = (input: Stream.Stream<string>) =>
  pipe(
    input,
    Stream.flatMap((line: string) => Stream.fromIterable(line.split(","))),
    Stream.map((range: string) => Schema.decodeUnknownSync(rangeSchema)(range)),
    Stream.flatMap((range) => Stream.range(range[0], range[2])),
    Stream.map(String)
  )

const part1 = (input: Stream.Stream<string>): Effect.Effect<number> => {
  return input.pipe(
    parseRanges,
    Stream.filter((x) => x.length % 2 === 0),
    Stream.filter((x) => x.slice(0, x.length / 2) === x.slice(x.length / 2)),
    Stream.map(Number),
    Stream.runSum
  )
}

const part2 = (input: Stream.Stream<string>): Effect.Effect<number> => {
  return input.pipe(
    parseRanges,
    Stream.filter((x) => {
      outer: for (let i = Math.floor(x.length / 2); i > 0; i--) {
        if (x.length % i !== 0) {
          continue
        }
        const needle = x.slice(0, i)
        for (let j = i; j < x.length; j += i) {
          if (needle !== x.slice(j, j + i)) {
            continue outer
          }
        }
        return true
      }
      return false
    }),
    Stream.map(Number),
    Stream.runSum
  )
}

export default Layer.succeed(Solution, { part1, part2 })
