import { Chunk, Effect, GroupBy, Layer, Match, Schema, Stream } from "effect"
import { Solution } from "./Solution.js"

const euclideanDistance = (
  [x1, y1, z1]: readonly [number, number, number],
  [x2, y2, z2]: readonly [number, number, number]
) => Math.sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2 + (z1 - z2) ** 2)

const pointSchema = Schema.TemplateLiteralParser(Schema.Int, ",", Schema.Int, ",", Schema.Int)

const part1 = (input: Stream.Stream<string>, isExample: boolean): Effect.Effect<number> =>
  Effect.gen(function*() {
    const points = yield* input.pipe(
      Stream.map(Schema.decodeUnknownSync(pointSchema)),
      Stream.map(([x, _, y, __, z]) => [x, y, z] as const),
      Stream.runCollect,
      Effect.map(Chunk.toArray)
    )

    const distances = yield* Stream.range(0, points.length - 2).pipe(
      Stream.flatMap((i) =>
        Stream.range(i + 1, points.length - 1).pipe(
          Stream.map((j) => [i, j]),
          Stream.map(([i, j]) => ({
            distance: euclideanDistance(points[i], points[j]),
            point1: i,
            point2: j,
            j
          }))
        )
      ),
      Stream.runCollect,
      Effect.map(Chunk.toArray)
    )
    distances.sort((a, b) => a.distance - b.distance)

    const pointToGroupMap = new Map<number, number>()
    for (let i = 0; i < points.length; i++) {
      pointToGroupMap.set(i, 0)
    }

    let groupCount = 0
    const connectionsToMake = isExample ? 10 : 1000
    for (let i = 0; i < connectionsToMake; i++) {
      const { point1, point2 } = distances[i]
      const group1 = pointToGroupMap.get(point1)!
      const group2 = pointToGroupMap.get(point2)!
      Match.value([group1, group2]).pipe(
        Match.when([0, 0], () => {
          groupCount++
          pointToGroupMap.set(point1, groupCount)
          pointToGroupMap.set(point2, groupCount)
        }),
        Match.when([0, Match.number], ([_, group2]) => {
          pointToGroupMap.set(point1, group2)
        }),
        Match.when([Match.number, 0], ([group1, _]) => {
          pointToGroupMap.set(point2, group1)
        }),
        Match.when([Match.number, Match.number], ([group1, group2]) => {
          if (group1 === group2) {
            return
          }
          for (const [point, group] of pointToGroupMap.entries()) {
            if (group === group1) {
              pointToGroupMap.set(point, group2)
            }
          }
        })
      )
    }

    const groupCounts = yield* Stream.fromIterable(pointToGroupMap.entries()).pipe(
      Stream.filter(([_, group]) => group !== 0),
      Stream.groupByKey(([_, group]) => group),
      GroupBy.evaluate((key, stream) =>
        stream.pipe(
          Stream.runCount,
          Effect.map((count) => ({ key, count }))
        )
      ),
      Stream.runCollect,
      Effect.map(Chunk.toArray),
      Effect.map((groupCounts) => groupCounts.sort((a, b) => b.count - a.count).slice(0, 3))
    )
    return groupCounts.reduce((acc, { count }) => acc * count, 1)
  })

const part2 = (input: Stream.Stream<string>): Effect.Effect<number> =>
  Effect.gen(function*() {
    const points = yield* input.pipe(
      Stream.map(Schema.decodeUnknownSync(pointSchema)),
      Stream.map(([x, _, y, __, z]) => [x, y, z] as const),
      Stream.runCollect,
      Effect.map(Chunk.toArray)
    )

    const distances = yield* Stream.range(0, points.length - 2).pipe(
      Stream.flatMap((i) =>
        Stream.range(i + 1, points.length - 1).pipe(
          Stream.map((j) => [i, j]),
          Stream.map(([i, j]) => ({
            distance: euclideanDistance(points[i], points[j]),
            point1: i,
            point2: j
          }))
        )
      ),
      Stream.runCollect,
      Effect.map(Chunk.toArray)
    )
    distances.sort((a, b) => a.distance - b.distance)

    const pointToGroupMap = new Map<number, number>()
    for (let i = 0; i < points.length; i++) {
      pointToGroupMap.set(i, 0)
    }

    const groups = new Set<number>()
    let noGroup = points.length

    let groupCount = 0
    for (let i = 0; i < distances.length; i++) {
      const { point1, point2 } = distances[i]
      const group1 = pointToGroupMap.get(point1)!
      const group2 = pointToGroupMap.get(point2)!
      Match.value([group1, group2]).pipe(
        Match.when([0, 0], () => {
          groupCount++
          pointToGroupMap.set(point1, groupCount)
          pointToGroupMap.set(point2, groupCount)
          noGroup--
          noGroup--
          groups.add(groupCount)
        }),
        Match.when([0, Match.number], ([_, group2]) => {
          pointToGroupMap.set(point1, group2)
          noGroup--
        }),
        Match.when([Match.number, 0], ([group1, _]) => {
          pointToGroupMap.set(point2, group1)
          noGroup--
        }),
        Match.when([Match.number, Match.number], ([group1, group2]) => {
          if (group1 === group2) {
            return
          }
          for (const [point, group] of pointToGroupMap.entries()) {
            if (group === group1) {
              pointToGroupMap.set(point, group2)
            }
          }
          groups.delete(group1)
        })
      )
      if (noGroup === 0 && groups.size === 1) {
        return points[point1][0] * points[point2][0]
      }
    }

    return 0
  })

export default Layer.succeed(Solution, { part1, part2 })
