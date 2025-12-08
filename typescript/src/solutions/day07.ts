import { Effect, Layer, Match, Option, Stream } from "effect"
import { Solution } from "./Solution.js"

const part1 = (input: Stream.Stream<string>): Effect.Effect<number> =>
  input.pipe(
    Stream.map((line) => line.split("")),
    Stream.sliding(2),
    Stream.runFold(0, (count, [prev, line]) => {
      for (let i = 0; i < line.length; i++) {
        Match.value([prev[i], line[i]]).pipe(
          // HACK: `line` is the exact same array as `prev` in the next iteration, so updating the values in place will affect the next iteration.
          Match.when(["S", "."], () => line[i] = "|"),
          Match.when(["|", "."], () => line[i] = "|"),
          Match.when(["|", "^"], () => {
            count++
            line[i - 1] = "|"
            line[i + 1] = "|"
          })
        )
      }
      return count
    })
  )

const part2 = (input: Stream.Stream<string>): Effect.Effect<number> =>
  input.pipe(
    Stream.map((line) =>
      line.split("").map((char) =>
        Match.value(char).pipe(
          Match.when("S", () => 1),
          Match.when(".", () => 0),
          Match.when("^", () => -1),
          Match.orElse(() => NaN)
        )
      )
    ),
    Stream.sliding(2),
    Stream.map(([prev, line]) => {
      for (let i = 0; i < line.length; i++) {
        Match.value([prev[i], line[i]]).pipe(
          // ignore/keep the 0 below a splitter
          Match.when([-1, Match.number], () => {}),
          // at a splitter, add the amount of timelines to the adjacent cells
          Match.when([Match.number, -1], ([prev, _]) => {
            line[i - 1] += prev
            line[i + 1] += prev
          }),
          // add the amount of incoming timelines to the current cell
          Match.when([Match.number, Match.number], ([prev, _]) => line[i] += prev)
        )
      }
      return line
    }),
    // get the last line
    Stream.runLast,
    Effect.map(Option.getOrThrow),
    Effect.map(Stream.fromIterable),
    // sum the amount of timelines ending in each cell
    Effect.flatMap(Stream.runSum)
  )

export default Layer.succeed(Solution, { part1, part2 })
