import * as fs from 'fs/promises' // For file system operations
import p from "path"
import { execSync } from 'child_process'

const gitUrl = 'https://github.com/Amazefcc233/mimir-docs'
const artifactPath = 'artifact'

/**
 *
 * @param {{version:string,payload:{version: any;  release_time: any;  release_note: any;  downloads: {};}}} param0
 */
export const modifyDocsRepoAndPush = async ({ version, payload, ssh = true }) => {
  version = version.startsWith("v") ? version.substring(1) : version
  execSync(`git clone ${gitUrl} mimir-deploy --single-branch --branch main --depth 1`)

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

  execSync(`git diff`)
  execSync(`git add .`)
  execSync(`git commit -m "Release New Version: ${version}"`)
  if (ssh) {
    execSync(`git push "git@github.com:Amazefcc233/mimir-docs" main:main`)
  } else {
    execSync(`git push main:main`)
  }
}
