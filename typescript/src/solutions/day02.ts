import * as Console from "effect/Console"
import * as Effect from "effect/Effect"
import { pipe } from "effect/Function"
import * as Schema from "effect/Schema"
import * as Stream from "effect/Stream"

export default function run(input: Stream.Stream<string>): Effect.Effect<void> {
  return Effect.gen(function*() {
    const rangeSchema = Schema.TemplateLiteralParser(
      Schema.Int,
      "-",
      Schema.Int
    )

    const ranges = pipe(
      input,
      Stream.flatMap((line: string) => Stream.fromIterable(line.split(","))),
      Stream.map((range: string) => Schema.decodeUnknownSync(rangeSchema)(range)),
      Stream.flatMap((range) => Stream.range(range[0], range[2]))
    )

    const resultPart1 = yield* ranges.pipe(
      Stream.map(String),
      Stream.filter((x) => x.length % 2 === 0),
      Stream.filter((x) => x.slice(0, x.length / 2) === x.slice(x.length / 2)),
      Stream.map(Number),
      Stream.runSum
    )

    const resultPart2 = yield* ranges.pipe(
      Stream.map(String),
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

    yield* Console.log("Day 2 Solution")
    yield* Console.log("Part 1: ", resultPart1)
    yield* Console.log("Part 2: ", resultPart2)
  })
}
