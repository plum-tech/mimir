import * as fs from 'fs/promises' // For file system operations
import { git } from './lib/git.mjs'
import { github, getGitHubMirrorDownloadUrl } from "./lib/github.mjs"
import * as path from "path"
import { getArtifactDownloadUrl } from './lib/sitmc.mjs'
import esMain from 'es-main'
import { searchAndGetAssetInfo } from "./lib/release.mjs"

const gitUrl = 'https://github.com/Amazefcc233/mimir-docs'
const deployPath = '~/deploy'
const artifactPath = 'artifact/'

const main = async () => {
  // Get release information from environment variables (GitHub Actions context)
  const version = getVersion()
  const releaseTime = getPublishTime()
  const releaseNote = getReleaseNote()
  console.log(version, releaseTime)

  const apk = await searchAndGetAssetInfo(({ name }) => path.extname(name) === ".apk")
  const ipa = await searchAndGetAssetInfo(({ name }) => path.extname(name) === ".ipa")

  // Generate artifact data
  const artifactPayload = buildArtifactPayload({ version, tagName: github.release.tag_name, releaseTime, releaseNote, apk, ipa })
  validateArtifactPayload(artifactPayload)

  // Write artifact data to JSON file
  const artifactJson = JSON.stringify(artifactPayload, null, 2)

  console.log(artifactJson)

  // Clone repository
  await git.clone(gitUrl, deployPath, { "--single-branch": null, "--branch": "main" })

  // Create artifact directory
  await fs.mkdir(artifactPath, { recursive: true })

  // Change directory
  process.chdir(deployPath)

  await fs.writeFile(`${artifactPath}${version}.json`, artifactJson)

  // Symlink latest.json to current version
  await fs.unlink(`${artifactPath}latest.json`) // Ignore if file doesn't exist
  await fs.symlink(`${version}.json`, `${artifactPath}latest.json`)

  await git.add(".")
  const diff = await git.diff()
  console.log(diff)
  await git.commit(`Release New Version: ${version}`)
  await git.push("git@github.com:Amazefcc233/mimir-docs", "main:main")
}


function getVersion() {
  // remove leading 'v'
  return github.release.tag_name.slice(1)
}

export function getReleaseNote() {
  const text = github.release.body
  const startLine = text.indexOf('## 更改')
  const endLine = text.indexOf('## How to download')

  if (startLine === -1 || endLine === -1) {
    throw new Error('Release notes section not found')
  }

  // Extract content between start and end lines (excluding headers)
  const releaseNotes = text.substring(startLine + '## 更改\n'.length, endLine).trim()

  // Remove any leading or trailing blank lines
  return releaseNotes.replace(/^\s*|\s*$/g, '')
}

function getPublishTime() {
  return new Date(github.release.published_at)
}

function buildArtifactPayload({ version, tagName, releaseTime, releaseNote, apk, ipa }) {
  const payload = {
    version,
    release_time: releaseTime,
    release_note: releaseNote,
    downloads: {},
  }
  if (apk) {
    payload.downloads.Android = {
      name: apk.name,
      default: 'official',
      sha256: apk.sha256,
      url: {
        official: getArtifactDownloadUrl({ tagName, fileName: apk.name }),
        github: apk.url,
        mirror: getGitHubMirrorDownloadUrl(apk.url),
      },
    }
  }
  if (ipa) {
    payload.downloads.iOS = {
      name: ipa.name,
      default: 'official',
      sha256: ipa.sha256,
      url: {
        official: getArtifactDownloadUrl({ tagName, fileName: ipa.namne }),
        github: ipa.url,
        mirror: getGitHubMirrorDownloadUrl(ipa.url),
      },
    }
  }
  return payload
}

const validateArtifactPayload = (payload) => {
  for (const [profile, download] of Object.entries(payload.downloads)) {
    if (!(download.default && download.url[download.default] !== undefined)) {
      if (download.url.length > 0) {
        download.default = download.url[0]
      } else {
        throw new Error(`No default download URL for ${profile}.`)
      }
    }
  }
}

if (esMain(import.meta)) {
  main()
}
