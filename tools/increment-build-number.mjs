import fs from 'fs/promises' // For file system operations
import { execSync } from 'child_process' // For shell commands
import { getVersion, getBuildNumber } from './pubspect.mjs'
const pubspecPath = 'pubspec.yaml'

function pushAndTagChanges(newVersion) {
  // Git operations (assuming arguments are provided)
  const serverUrl = process.argv[2]
  const repository = process.argv[3]
  const runId = process.argv[4]
  const runAttempt = process.argv[5]

  execSync(`git add .`, { shell: true })

  execSync(`git commit -m "build: ${newVersion}"`, { shell: true })

  execSync(`git tag -a v${newVersion} -m "v${newVersion}\nrun id: ${runId}\nrun_attempt(should be 1): ${runAttempt}\n${serverUrl}/${repository}/actions/runs/${runId}"`, { shell: true })
}

async function main() {
  // Read pubspec.yaml content
  const filedata = await fs.readFile(pubspecPath, 'utf-8')

  // Extract version and build number
  const version = getVersion(filedata)

  const buildNumber = getBuildNumber(filedata)

  // Generate new version and print information
  const oldVersion = `${version}+${buildNumber}`
  const newVersion = `${version}+${buildNumber + 1}`
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
    pushAndTagChanges(newVersion)
  }
}

main()
