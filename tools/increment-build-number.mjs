import fs from 'fs/promises' // For file system operations
import { extractVersion, extractBuildNumber } from './pubspec.mjs'
import { git } from "./git.mjs"
import { guardVersioning } from './guard.mjs'
const pubspecPath = 'pubspec.yaml'

/**
 *
 * @param {string} newVersion
 */
async function pushAndTagChanges(newVersion) {
  // Git operations (assuming arguments are provided)
  const serverUrl = process.argv[2]
  const repository = process.argv[3]
  const runId = process.argv[4]
  const runAttempt = process.argv[5]

  await git.add(".")
  await git.commit(`build: ${newVersion}`)
  await git.tag({
    "-a": `v${newVersion}`,
    "-m": `v${newVersion}
    run id: ${runId}
    run_attempt(should be 1): ${runAttempt}
    ${serverUrl}/${repository}/actions/runs/${runId}`,
  })
}

async function main() {
  // Read pubspec.yaml content
  const filedata = await fs.readFile(pubspecPath, 'utf-8')

  // Extract version and build number
  const version = extractVersion(filedata)

  const buildNumber = extractBuildNumber(filedata)

  // Generate new version and print information
  const oldVersion = `${version}+${buildNumber}`
  const newVersion = `${version}+${buildNumber + 1}`
  await guardVersioning(newVersion)

  console.log(`new version: ${newVersion}`)
  console.log(`build bumber: ${buildNumber} -> ${buildNumber + 1}`)

  // Update version in pubspec.yaml
  const updatedFiledata = filedata.replace(
    `version: ${oldVersion}`,
    `version: ${newVersion}`,
  )

  await fs.writeFile(pubspecPath, updatedFiledata)

  // Check for additional arguments
  if (process.argv.length > 2) {
    await pushAndTagChanges(newVersion)
  }
}

main()
