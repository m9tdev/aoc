# Advent of Code CLI

A CLI tool for running Advent of Code solutions using Effect TypeScript.

## Usage

After building, run solutions with:

```sh
aoc <day>
```

For example:

```sh
aoc 1    # Run solution for day 1
aoc 25   # Run solution for day 25
```

## Adding Solutions

1. Create a solution file at `src/solutions/dayXX.ts` (e.g., `day01.ts`, `day02.ts`)
2. Export a default function that returns an `Effect.Effect<void>`
3. Register it in `src/solutions/index.ts`

Example solution:

```typescript
import * as Console from "effect/Console"
import * as Effect from "effect/Effect"

export default function run() {
  return Effect.gen(function* () {
    yield* Console.log("Day 1 Solution")
    // Your solution code here
  })
}
```

## Development

**Building**

To build the package:

```sh
pnpm build
```

**Running in Development**

You can run the CLI directly with tsx:

```sh
pnpm tsx src/bin.ts 1
```

**Testing**

To test the package:

```sh
pnpm test
```
