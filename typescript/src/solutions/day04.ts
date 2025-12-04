import * as Effect from "effect/Effect"
import * as Layer from "effect/Layer"
import * as Stream from "effect/Stream"
import { Solution } from "./Solution.js"

const neighbors = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]] as const

const diagramFromInput = (input: Stream.Stream<string>): Effect.Effect<Array<Array<string>>> =>
  input.pipe(
    // add padding to prevent boundary checks
    Stream.map((line) => "." + line + "."),
    Stream.map((line) => line.split("")),
    Stream.runFold([] as Array<Array<string>>, (acc, line) => [...acc, line]),
    Effect.map((diagram) => [
      Array(diagram[0].length).fill("."), // add padding
      ...diagram,
      Array(diagram[0].length).fill(".") // add padding
    ])
  )

const part1 = (input: Stream.Stream<string>): Effect.Effect<number> =>
  Effect.gen(function*() {
    const diagram = yield* diagramFromInput(input)

    let accessible = 0
    for (let y = 1; y < diagram.length - 1; y++) {
      for (let x = 1; x < diagram[y].length - 1; x++) {
        if (diagram[y][x] === "@") {
          let count = 0
          for (const [dy, dx] of neighbors) {
            if (diagram[y + dy][x + dx] === "@") {
              count++
            }
          }
          if (count < 4) {
            accessible++
          }
        }
      }
    }

    return accessible
  })

const part2 = (input: Stream.Stream<string>): Effect.Effect<number> =>
  Effect.gen(function*() {
    const diagram = yield* diagramFromInput(input)

    let accessibleCount = 0
    while (true) {
      const lastAccessibleCount = accessibleCount
      const accessible = [] as Array<[number, number]>
      for (let y = 1; y < diagram.length - 1; y++) {
        for (let x = 1; x < diagram[y].length - 1; x++) {
          if (diagram[y][x] === "@") {
            let count = 0
            for (const [dy, dx] of neighbors) {
              if (diagram[y + dy][x + dx] === "@") {
                count++
              }
            }
            if (count < 4) {
              accessibleCount++
              accessible.push([y, x])
            }
          }
        }
      }
      for (const [y, x] of accessible) {
        diagram[y][x] = "x"
      }
      if (lastAccessibleCount === accessibleCount) {
        break
      }
    }

    return accessibleCount
  })

export default Layer.succeed(Solution, { part1, part2 })
