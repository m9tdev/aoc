import { cpSync, existsSync, readFileSync, rmSync, writeFileSync } from "fs"

// Clean dist directory
if (existsSync("dist")) {
  rmSync("dist", { recursive: true, force: true })
}

// Copy all source files - Bun can run TypeScript directly
console.log("Copying source files...")
cpSync("src", "dist", { recursive: true })

// Copy package.json to dist
console.log("Copying package.json...")
const pkg = JSON.parse(readFileSync("package.json", "utf-8"))
const distPkg = {
  name: pkg.name,
  version: pkg.version,
  type: pkg.type,
  description: pkg.description,
  bin: { aoc: "./bin.ts" },
  publishConfig: pkg.publishConfig
}
writeFileSync("dist/package.json", JSON.stringify(distPkg, null, 2))
console.log("Build completed!")
