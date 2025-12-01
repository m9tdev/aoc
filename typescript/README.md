# Advent of Code CLI

A CLI tool for running Advent of Code solutions using Effect TypeScript.

## Usage

After building, run solutions with:

```sh
aoc run <day>
```

For example:

```sh
aoc run 1    # Run solution for day 1
aoc run 25   # Run solution for day 25
```

### Downloading Input

To download input for a day, use the download subcommand:

```sh
aoc download <day> [year]
```

For example:

```sh
aoc download 1        # Download input for day 1 (current year)
aoc download 1 2023  # Download input for day 1, year 2023
```

**Note:** You need to set the `AOC_SESSION` environment variable with your session cookie from adventofcode.com:

```sh
export AOC_SESSION=your_session_cookie_here
```

Get your session cookie from your browser's cookies when logged into https://adventofcode.com.

The input will be saved to `inputs/YYYY-dayXX.txt` (e.g., `inputs/2024-day01.txt`).

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
pnpm tsx src/bin.ts run 1
pnpm tsx src/bin.ts download 1
```

**Testing**

To test the package:

```sh
pnpm test
```
