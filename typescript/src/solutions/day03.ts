import type * as Effect from "effect/Effect"
import * as Layer from "effect/Layer"
import * as Stream from "effect/Stream"
import { Solution } from "./Solution.js"

const part1 = (input: Stream.Stream<string>): Effect.Effect<number> => {
  return input.pipe(
    Stream.map((line) => {
      let max1 = 0
      let max2 = 0
      let max1i = 0
      for (let i = 0; i < (line.length - 1); i++) {
        const digit = Number(line[i])
        if (digit > max1) {
          max1 = digit
          max1i = i
        }
      }
      for (let j = max1i + 1; j < line.length; j++) {
        max2 = Math.max(max2, Number(line[j]))
      }
      return max1 * 10 + max2
    }),
    Stream.runSum
  )
}

const part2 = (input: Stream.Stream<string>): Effect.Effect<number> => {
  const maxLength = 12
  return input.pipe(
    Stream.map((line) => {
      let res = ""
      let start = 0 // index after the last found number
      for (let i = 0; i < maxLength; i++) {
        // leave room for the following numbers
        const end = line.length - maxLength + i
        let max = 0
        // search for the maximum number in the range
        for (let j = start; j <= end; j++) {
          const digit = Number(line[j])
          if (digit > max) {
            max = digit
            // start the next search after the current number
            start = j + 1
          }
        }
        res += String(max)
      }
      return Number(res)
    }),
    Stream.runSum
  )
}

export default Layer.succeed(Solution, { part1, part2 })
