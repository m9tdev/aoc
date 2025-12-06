import { Effect, Layer, Stream } from "effect"
import { Solution } from "./Solution.js"

const part1 = (input: Stream.Stream<string>): Effect.Effect<number, never, never> =>
  input.pipe(
    Stream.map((line) => line.trim().split(/\s+/)),
    Stream.map(Stream.fromIterable),
    Stream.runFold(
      Stream.iterate([] as Array<string>, (_) => []),
      (acc, stream) => acc.pipe(Stream.zipFlatten(stream))
    ),
    Effect.flatMap((numbersStream) => {
      const problemStream = numbersStream.pipe(
        Stream.map((arr) => {
          const numbers = arr.slice(0, arr.length - 1).map(Number)
          const operator = arr[arr.length - 1]!
          return { numbers, operator }
        })
      )
      return problemStream.pipe(
        Stream.map(({ numbers, operator }) => {
          const op = operator === "+" ?
            (a: number, b: number) => a + b :
            (a: number, b: number) => a * b
          const result = numbers.reduce(op, operator === "+" ? 0 : 1)
          return result
        }),
        Stream.runSum
      )
    })
  )

const part2 = (input: Stream.Stream<string>): Effect.Effect<number> =>
  input.pipe(
    Stream.map((line) => line.split("").reverse()),
    Stream.map(Stream.fromIterable),
    Stream.runFold(
      Stream.iterate("", (_) => ""),
      (acc, s) => acc.pipe(Stream.zip(s), Stream.map(([a, b]) => a + b))
    ),
    Effect.flatMap((columnStream) =>
      columnStream.pipe(
        Stream.runFold(
          { total: 0, numbers: [] as Array<number> },
          (acc, column) => {
            // ignore empty columns
            if (column.trim() === "") return acc
            if (column.endsWith(" ")) {
              return {
                ...acc,
                numbers: [...acc.numbers, Number(column)]
              }
            }
            // ends with "+" or "*"
            const numbers = [...acc.numbers, Number(column.slice(0, -1))]
            const total = column.endsWith("+") ?
              numbers.reduce((a, b) => a + b, 0) :
              numbers.reduce((a, b) => a * b, 1)
            return {
              total: acc.total + total,
              numbers: []
            }
          }
        ),
        Effect.map(({ total }) => total)
      )
    )
  )

export default Layer.succeed(Solution, { part1, part2 })
