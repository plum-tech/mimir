import * as fs from 'fs/promises' // For file system operations
import { gitOf } from './git.mjs'
import p from "path"

const gitUrl = 'https://github.com/Amazefcc233/mimir-docs'
const artifactPath = 'artifact'

/**
 *
 * @param {{version:string,payload:{version: any;  release_time: any;  release_note: any;  downloads: {};}}} param0
 */
export const modifyDocsRepoAndPush = async ({ version, payload }) => {
  let git = gitOf()
  // Clone repository
  await git.clone(gitUrl, "mimir-deploy", {
    "--single-branch": null, "--branch": "main", "--depth": 1
  })
  git = gitOf("mimir-deploy")
  git.init().addRemote()
  // Create artifact directory
  await fs.mkdir(artifactPath, { recursive: true })

  // Change directory
  process.chdir("mimir-deploy")
  console.log(`The cwd is ${process.cwd()}`)

  // Write artifact data to JSON file
  const jsonString = JSON.stringify(payload, null, 2)

  await fs.writeFile(p.join(artifactPath, `${version}.json`), jsonString)
  console.log(jsonString)

  // Symlink latest.json to current version
  await fs.unlink(p.join(artifactPath, `latest.json`)) // Ignore if file doesn't exist
  await fs.symlink(`${version}.json`, p.join(artifactPath, `latest.json`))

  const diff = await git.diff()
  console.log(diff)
  await git.add(".")
  await git.commit(`Release New Version: ${version}`)
  await git.push("git@github.com:Amazefcc233/mimir-docs", "main:main")
}
