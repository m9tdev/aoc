import * as Chunk from "effect/Chunk"
import * as Effect from "effect/Effect"
import * as Layer from "effect/Layer"
import * as Sink from "effect/Sink"
import * as Stream from "effect/Stream"
import { Solution } from "./Solution.js"

const splitRangesAndIndices = (input: Stream.Stream<string>) =>
  Effect.gen(function*() {
    const [rangesChunk, remainingStream] = yield* input.pipe(
      Stream.peel(Sink.collectAllWhile((line: string) => line !== ""))
    )

    const ranges = rangesChunk.pipe(
      Chunk.map((line) => {
        const [start, end] = line.split("-").map(Number)
        return { start, end }
      }),
      Chunk.toArray
    )

    const indexStream = remainingStream.pipe(
      Stream.drop(1),
      Stream.map(Number)
    )

    return { ranges, indexStream }
  })

const part1 = (input: Stream.Stream<string>): Effect.Effect<number> =>
  Effect.scoped(
    Effect.gen(function*() {
      const { indexStream, ranges } = yield* splitRangesAndIndices(input)

      const result = yield* indexStream.pipe(
        Stream.map((index) => ranges.some((range) => (index >= range.start && index <= range.end))),
        Stream.filter(Boolean),
        Stream.runCount
      )

      return result
    })
  )

const part2 = (input: Stream.Stream<string>): Effect.Effect<number> =>
  Effect.scoped(
    Effect.gen(function*() {
      const { ranges } = yield* splitRangesAndIndices(input)
      const sortedRanges = ranges.sort((a, b) => a.start - b.start)
      return yield* Stream.fromIterable(sortedRanges).pipe(
        Stream.runFold({ total: 0, lastRange: { start: 0, end: 0 } }, (acc, range) => {
          const lastRange = acc.lastRange
          // range is completely contained in the last range
          if (range.end <= lastRange.end) return acc
          // range overlaps with the last range
          if (range.start <= lastRange.end) {
            return {
              total: acc.total + (range.end - lastRange.end),
              lastRange: { start: lastRange.start, end: range.end }
            }
          }
          return {
            total: acc.total + (range.end - range.start + 1),
            lastRange: range
          }
        }),
        Effect.map((result) => result.total)
      )
    })
  )

export default Layer.succeed(Solution, { part1, part2 })
