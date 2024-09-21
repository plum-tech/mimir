import fs from 'fs/promises' // For file system operations
import { extractVersion, extractBuildNumber } from './lib/pubspec.js'
import { git } from "./lib/git.js"
import { guardVersioning } from './lib/guard.js'
import esMain from 'es-main'
const pubspecPath = 'pubspec.yaml'
import { context } from './lib/github.js'
import { cli } from '@liplum/cli'

/**
 *
 * @param {string} newVersion
 */
const pushAndTagChanges = async (newVersion) => {
  // Git operations (assuming arguments are provided)
  const serverUrl = context.serverUrl
  const repository = `${context.repo.owner}/${context.repo.repo}`
  const runId = context.runId

  await git.add(".")
  await git.commit(`build: ${newVersion}`)
  await git.tag([
    "-a", `v${newVersion}`,
    "-m", `v${newVersion}
    run id: ${runId}
    ${serverUrl}/${repository}/actions/runs/${runId}`,
  ])
}

const main = async () => {
  const args = cli({
    name: 'increment-build-number',
    description: 'Increment build number by 1.',
    examples: ['node ./increment-build-number.js', 'node ./increment-build-number.js --push'],
    require: [],
    options: [{
      name: 'push',
      type: Boolean,
      description: 'Whether to tag and push.'
    },],
  })
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
  if (args.push) {
    await pushAndTagChanges(newVersion)
  }
}

if (esMain(import.meta)) {
  main()
}
