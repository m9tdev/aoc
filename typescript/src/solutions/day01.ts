import * as Effect from "effect/Effect"
import * as Layer from "effect/Layer"
import * as Stream from "effect/Stream"
import { Solution } from "./Solution.js"

const parseLine = (line: string) => {
  const sign = line[0] === "L" ? -1 : 1
  const value = parseInt(line.slice(1), 10)
  return { sign, value }
}

const part1 = (input: Stream.Stream<string>): Effect.Effect<number> => {
  return input.pipe(
    Stream.map(parseLine),
    Stream.runFold(
      { position: 50, count: 0 },
      (acc, { sign, value }) => {
        const position = (acc.position + (sign * value) + 100) % 100
        const count = acc.count + (position === 0 ? 1 : 0)
        return ({ position, count })
      }
    ),
    Effect.map((result) => result.count)
  )
}

const part2 = (input: Stream.Stream<string>): Effect.Effect<number> => {
  return input.pipe(
    Stream.map(parseLine),
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
    ),
    Effect.map((result) => result.count)
  )
}

export default Layer.succeed(Solution, { part1, part2 })
