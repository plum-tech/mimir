import { git } from "./git.mjs"
async function main() {
  console.log(`v{newVersion}
  run id: {runId}
  run_attempt(should be 1): {runAttempt}
  {serverUrl}/{repository}/actions/runs/{runId}`)
}

main()
