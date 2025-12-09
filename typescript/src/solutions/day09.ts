import { Chunk, Effect, Layer, Schema, Stream } from "effect"
import { Solution } from "./Solution.js"

const lineSchema = Schema.TemplateLiteralParser(
  Schema.Int,
  ",",
  Schema.Int
)

const area = (
  [x1, y1]: readonly [number, number],
  [x2, y2]: readonly [number, number]
) => (Math.abs(x1 - x2) + 1) * (Math.abs(y1 - y2) + 1)

const part1 = (input: Stream.Stream<string>): Effect.Effect<number> =>
  Effect.gen(function*() {
    const points = yield* input.pipe(
      Stream.map(Schema.decodeUnknownSync(lineSchema)),
      Stream.map(([x, _, y]) => [x, y] as const),
      Stream.runCollect,
      Effect.map(Chunk.toArray)
    )

    const distances = yield* Stream.range(0, points.length - 2).pipe(
      Stream.flatMap((i) =>
        Stream.range(i + 1, points.length - 1).pipe(
          Stream.map((j) => [i, j]),
          Stream.map(([i, j]) => area(points[i], points[j]))
        )
      ),
      Stream.runCollect,
      Effect.map(Chunk.toArray)
    )
    distances.sort((a, b) => a - b)

    return distances[distances.length - 1]
  })

const part2 = (input: Stream.Stream<string>): Effect.Effect<number> =>
  Effect.gen(function*() {
    const pointStream = input.pipe(
      Stream.map(Schema.decodeUnknownSync(lineSchema)),
      Stream.map(([x, _, y]) => [x, y] as const)
    )

    const points = yield* pointStream.pipe(
      Stream.runCollect,
      Effect.map(Chunk.toArray)
    )

    const lines = yield* pointStream.pipe(
      Stream.sliding(2),
      Stream.map(([point1, point2]) => [point1, point2] as const),
      Stream.runCollect,
      Effect.map(Chunk.toArray)
    )

    const distances = yield* Stream.range(0, points.length - 2).pipe(
      Stream.flatMap((i) =>
        Stream.range(i + 1, points.length - 1).pipe(
          Stream.map((j) => [i, j]),
          Stream.filter(([i, j]) => {
            const minX = Math.min(points[i][0], points[j][0])
            const maxX = Math.max(points[i][0], points[j][0])
            const minY = Math.min(points[i][1], points[j][1])
            const maxY = Math.max(points[i][1], points[j][1])
            // check if some line intersects with the rectangle
            return !lines.some(([lineStart, lineEnd]) => {
              const lineX1 = lineStart[0]
              const lineX2 = lineEnd[0]
              const lineY1 = lineStart[1]
              const lineY2 = lineEnd[1]
              return (lineX1 < maxX && lineX2 > minX && lineY1 < maxY && lineY2 > minY) ||
                (lineX1 < maxX && lineX2 > minX && lineY1 > minY && lineY2 < maxY) ||
                (lineX1 > minX && lineX2 < maxX && lineY1 < maxY && lineY2 > minY) ||
                (lineX1 > minX && lineX2 < maxX && lineY1 > minY && lineY2 < maxY)
            })
          }),
          Stream.map(([i, j]) => area(points[i], points[j]))
        )
      ),
      Stream.runCollect,
      Effect.map(Chunk.toArray)
    )
    distances.sort((a, b) => a - b)

    return distances[distances.length - 1]
  })

export default Layer.succeed(Solution, { part1, part2 })
