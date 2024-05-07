import fs from 'fs/promises' // For file system operations
import { execSync } from 'child_process' // For shell commands

const pubspecPath = 'pubspec.yaml'

function getVersion(pubspec) {
  const versionMatch = pubspec.match(/version: (\d+.\d+.\d+)/)
  if (!versionMatch) {
    throw new Error('Could not find version in pubspec.yaml')
  }
  return versionMatch[1]
}

function getBuildNumber(pubspec) {
  const buildNumberMatch = filedata.match(/version: \d+.\d+.\d+(\+\d+)/)
  return buildNumberMatch ? parseInt(buildNumberMatch[1].slice(1)) : 0
}

async function main() {
  // Read pubspec.yaml content
  const filedata = await fs.readFile(pubspecPath, 'utf-8')

  // Extract version and build number
  const version = getVersion(filedata)

  const buildNumber = getBuildNumber(filedata)

  // Generate new version and print information
  const oldVersion = version + '+' + buildNumber
  const newVersion = version + '+' + buildNumber + 1
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

main().catch(error => {
  console.error(error)
  process.exit(1)
})
