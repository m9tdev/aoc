import * as FileSystem from "@effect/platform/FileSystem"
import * as HttpClient from "@effect/platform/HttpClient"
import * as HttpClientRequest from "@effect/platform/HttpClientRequest"
import * as Path from "@effect/platform/Path"
import * as Console from "effect/Console"
import * as Effect from "effect/Effect"
import { getAocSession } from "./loadEnv.js"

const AOC_BASE_URL = "https://adventofcode.com"

export const downloadInput = (day: number, year: number = new Date().getFullYear()) =>
  Effect.gen(function*() {
    const fs = yield* FileSystem.FileSystem
    const path = yield* Path.Path

    // Get session cookie from environment or .env file
    const sessionCookie = yield* getAocSession()
    if (!sessionCookie) {
      yield* Console.error("AOC_SESSION environment variable is not set")
      yield* Console.log("Get your session cookie from https://adventofcode.com (check browser cookies)")
      yield* Console.log("Then set it in a .env file: AOC_SESSION=your_session_cookie")
      yield* Console.log("Or set it as an environment variable: export AOC_SESSION=your_session_cookie")
      return
    }

    const dayStr = day.toString().padStart(2, "0")
    const url = `${AOC_BASE_URL}/${year}/day/${day}/input`

    yield* Console.log(`Downloading input for day ${day} (${year})...`)

    // Make HTTP request
    const request = HttpClientRequest.get(url).pipe(
      HttpClientRequest.setHeader("Cookie", `session=${sessionCookie}`)
    )

    const response = yield* HttpClient.execute(request)
    const body = yield* response.text

    // Ensure inputs directory exists
    const inputsDir = path.join(process.cwd(), "inputs")
    const dirExists = yield* fs.exists(inputsDir)
    if (!dirExists) {
      yield* fs.makeDirectory(inputsDir, { recursive: true })
    }

    // Save input file with year prefix
    const inputPath = path.join(inputsDir, `${year}-day${dayStr}.txt`)
    yield* fs.writeFileString(inputPath, body)
    yield* Console.log(`Input saved to ${inputPath}`)
  })
