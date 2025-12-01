import * as FileSystem from "@effect/platform/FileSystem"
import * as Console from "effect/Console"
import * as Effect from "effect/Effect"
import { pipe } from "effect/Function"
import * as Stream from "effect/Stream"

export default function run() {
  return Effect.gen(function*() {
    const fs = yield* FileSystem.FileSystem
    const rotations = pipe(
      fs.stream("inputs/2025-day01.txt"),
      Stream.decodeText("utf-8"),
      Stream.splitLines,
      Stream.map((line) => {
        const sign = line[0] === "L" ? -1 : 1
        const value = parseInt(line.slice(1), 10)
        return { sign, value }
      })
    )
    const resultPart1 = yield* pipe(
      rotations,
      Stream.runFold(
        { position: 50, count: 0 },
        (acc, { sign, value }) => {
          const position = (acc.position + (sign * value) + 100) % 100
          const count = acc.count + (position === 0 ? 1 : 0)
          return ({ position, count })
        }
      )
    )
    const resultPart2 = yield* pipe(
      rotations,
      Stream.runFold(
        { position: 50, count: 0 },
        (prev, { sign, value }) => {
          const effectiveValue = value % 100
          const intermediatePosition = prev.position + (sign * effectiveValue)
          const position = (intermediatePosition + 100) % 100
          const rotations = Math.floor(value / 100) +
            (((intermediatePosition <= 0 || intermediatePosition >= 100) && effectiveValue > 0 && prev.position !== 0)
              ? 1
              : 0)
          const count = prev.count + rotations
          return ({ position, count })
        }
      )
    )

    yield* Console.log("Day 1 Solution")
    yield* Console.log("Part 1: ", resultPart1.count)
    yield* Console.log("Part 2: ", resultPart2.count)
  })
}
