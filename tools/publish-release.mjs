import * as fs from 'fs/promises' // For file system operations
import { git, github } from './git.mjs'
import crypto from "crypto"
import * as path from "path"
import { getArtifactDownloadUrl } from './sitmc.mjs'

const gitUrl = 'https://github.com/Amazefcc233/mimir-docs'
const deployPath = '~/deploy'
const artifactPath = 'artifact/'

async function main() {
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

  await addAndPush({ version })
}

function withGitHubMirror(url) {
  return `https://mirror.ghproxy.com/${url}`
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
        official: getArtifactDownloadUrl(tagName, apk.name),
        github: apk.url,
        mirror: withGitHubMirror(apk.url),
      },
    }
  }
  if (ipa) {
    payload.downloads.iOS = {
      name: ipa.name,
      default: 'official',
      sha256: ipa.sha256,
      url: {
        official: getArtifactDownloadUrl(tagName, ipa.name),
        github: ipa.url,
        mirror: withGitHubMirror(ipa.url),
      },
    }
  }
  return payload
}

function validateArtifactPayload(payload) {
  for (const [profile, download] in Object.entries(payload.downloads)) {
    if (!(download.default && download.url[download.default] !== undefined)) {
      if (download.url.length > 0) {
        download.default = download.url[0]
      } else {
        throw new Error(`No default download URL for ${profile}.`)
      }
    }
  }
}
/**
 *
 * @param {{version:string}} param0
 */
async function addAndPush({ version }) {
  await git.add(".")
  await git.commit(`Release New Version: ${version}`)
  await git.push("git@github.com:Amazefcc233/mimir-docs", "main:main")
}

function getVersion() {
  // remove leading 'v'
  return github.release.tag_name.slice(1)
}

function getReleaseNote() {
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

/**
 * @param {({name:string,browser_download_url:string})=>boolean} filter
 */
async function searchAndGetAssetInfo(filter) {
  const asset = searchAsset(filter)
  if (!asset) return
  return await getAssetInfo(asset)
}

/**
 * @template {{name:string,browser_download_url:string}} T
 * @param {(T)=>boolean} filter
 * @returns {T | undefined}
 */
function searchAsset(filter) {
  const assets = github.release.assets
  for (const asset of assets) {
    if (filter(asset)) {
      return asset
    }
  }
  return
}

/**
 *
 * @param {{name:string,browser_download_url:string}} payload
 */
async function getAssetInfo(payload) {
  const url = payload.browser_download_url
  let sha256 = ""
  if (url) {
    sha256 = await downloadAndSha256Hash(url)
  }
  return {
    name: payload.name,
    url: url,
    sha256: sha256,
  }
}

/**
 *
 * @param {string} url
 */
async function downloadAndSha256Hash(url) {
  const response = await fetch(url)
  const chunks = []
  for await (const chunk of response.body) {
    chunks.push(chunk)
  }
  const buffer = Buffer.concat(chunks)
  const hash = crypto.createHash('sha256').update(buffer).digest('hex')
  return hash
}

main()
