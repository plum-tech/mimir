import "dotenv/config"
import { getOctokit } from "@actions/github"
import env from "@liplum/env"
import * as fs from "fs"
import * as fsp from "fs/promises"
import * as p from "path"
import { pipeline } from "stream/promises"
import { unzipFile } from "./lib/unzip.mjs"
import axios from "axios"
import { getLatestTag } from "./lib/git.mjs"
import esMain from "es-main"

const githubToken = env("GITHUB_TOKEN").string()

const net = axios.create({
  headers: {
    Authorization: `token ${githubToken}`
  }
})

const octokit = getOctokit(githubToken)

/**
 *
 * @param {string} path
 */
const getLatestWorkflowRun = async (path) => {
  const res = await octokit.rest.actions.listWorkflowRunsForRepo({
    owner: "plum-tech",
    repo: "mimir",
    branch: "master",
    event: "workflow_dispatch",
    status: "success",
  })
  const runs = res.data.workflow_runs.filter(run => run.path.endsWith(path))
  const latest = runs[0]
  return latest
}

/**
 *
 * @param {string} runId
 */
const getArtifactsFromWorkflowRun = async (runId) => {
  const res = await octokit.rest.actions.listWorkflowRunArtifacts({
    owner: "plum-tech",
    repo: "mimir",
    run_id: runId,
  })
  return res.data.artifacts
}

/**
 *
 * @param {typeof artifacts} artifacts
 * @param {string} name
 */
const findPlatform = (artifacts, name) => {
  return artifacts.find(artifact => artifact.name.toLowerCase().includes(name.toLowerCase()))
}

/**
 *
 * @param {typeof android} artifcat
 * @param {string} path
 */
const downloadArtifact = async (artifcat, path) => {
  if (fs.existsSync(path)) return
  await fsp.mkdir(p.dirname(path), { recursive: true })
  const ws = fs.createWriteStream(path)
  const res = await net.get(artifcat.archive_download_url, {
    responseType: "stream",
    onDownloadProgress: (e) => {
      console.log(`${path}: ${(e.progress * 100).toFixed(2)}%`)
    }
  })
  await pipeline(res.data, ws)
}
const artifactsDir = "artifacts"
/**
 *
 * @param {typeof android} artifact
 * @param string filename
 */
const downloadArtifactAndUnzip = async (artifact, filename) => {
  const path = p.join(artifactsDir, `${filename}.zip`)
  await downloadArtifact(artifact, path)
  const dest = p.join(artifactsDir, filename)
  if (fs.existsSync(dest)) return
  await unzipFile(path, dest)
}


const getPreviousTag = async () => {
  const res = await octokit.rest.repos.getLatestRelease({
    owner: "plum-tech",
    repo: "mimir",
  })
  const data = res.data
  return data.tag_name
}

/**
 *
 * @param {{tag:string,body:string}} param0
 */
const createReleaseDraft = async ({ tag, body }) => {
  try {
    const check = await octokit.rest.repos.getReleaseByTag({
      owner: "plum-tech",
      repo: "mimir",
      tag,
    })
    if (check.status === 200) {
      console.log(`Release of ${tag} already created.`)
      return check.data.id
    }
  } catch {
    console.log(`Creating ${tag}`)
  }
  const res = await octokit.rest.repos.createRelease({
    owner: "plum-tech",
    repo: "mimir",
    name: tag,
    tag_name: tag,
    body,
    draft: true,
    prerelease: false,
  })
  return res.data.id
}
/**
 *
 * @param {string} releaseId
 * @param {{localFile:string, filename?:string}} param1
 */
const uploadReleaseAsset = async (releaseId, { localFile, filename, }) => {
  if (!filename) {
    filename = p.basename(filename)
  }
  const buffer = await fsp.readFile(localFile)
  await octokit.rest.repos.uploadReleaseAsset({
    owner: "plum-tech",
    repo: "mimir",
    name: filename,
    release_id: releaseId,
    data: buffer,
    headers: {
      "Content-Type": "application/octet-stream",
    },
  })
}

/**
 *
 * @param {{previousTag:string, currentTag:string}}} param0
 * @returns
 */
const generateReleaseBody = ({
  previousTag, currentTag
}) => {
  return `
## Changes
  - Fixed:
  - Added:

## 更改
  - 修复 |
  - 新增 |

## How to download
  - Android: Click the .apk files below.
  - iOS: Download on the [App Store](https://testflight.apple.com/join/hPeQ13fe), or join the [Test Flight](https://testflight.apple.com/join/2n5I09Zv).


Full Changelog: https://github.com/plum-tech/mimir/compare/${previousTag}...${currentTag}
`
}

const main = async () => {
  const latest = await getLatestWorkflowRun("build.yml")
  console.log(latest)

  const artifacts = await getArtifactsFromWorkflowRun(latest.id)
  console.log(artifacts)

  const android = findPlatform(artifacts, "Android")
  const iOS = findPlatform(artifacts, "iOS")

  if (!android) throw new Error("Missing Android artifacts")
  if (!iOS) throw new Error("Missing iOS artifacts")

  await Promise.all([
    downloadArtifactAndUnzip(android, "android"),
    downloadArtifactAndUnzip(iOS, "ios"),
  ])

  const latestTag = await getLatestTag()
  const previousTag = await getPreviousTag()

  const body = generateReleaseBody({ previousTag, currentTag: latestTag, })
  const releaseId = await createReleaseDraft({
    tag: latestTag,
    body,
  })

  await uploadReleaseAsset(releaseId, {
    localFile: p.join(artifactsDir, "android", "app-release-signed.apk"),
    filename: `sitlife-${latestTag}.apk`,
  })
}

if (esMain(import.meta)) {
  main()
}
