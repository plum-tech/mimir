import { execSync } from 'child_process' // For shell commands
import * as fs from 'fs/promises' // For file system operations
import * as https from 'https' // For downloading files
import { git, github } from './git.mjs'
import crypto from "crypto"
import * as path from "path"

const gitUrl = 'https://github.com/Amazefcc233/mimir-docs'
const deployPath = '~/deploy'
const artifactPath = 'artifact/'

async function main() {
  // Clone repository
  await git.clone(gitUrl, deployPath, { "--single-branch": null, "--branch": "main" })

  // Change directory
  process.chdir(deployPath)

  // Get release information from environment variables (GitHub Actions context)
  const version = getVersion()
  const releaseTime = getPublishTime()
  const releaseNote = getReleaseNote()
  const apkInfo = await searchAndGetAssetInfo(({ name }) => path.extname(name) === ".apk")
  const ipaInfo = await searchAndGetAssetInfo(({ name }) => path.extname(name) === ".ipa")

  // Create artifact directory
  await fs.mkdir(artifactPath, { recursive: true })


  // Generate artifact data
  const artifactData = {
    version,
    release_time: releaseTime,
    release_note: releaseNote,
    downloads: {
      Android: {
        name: apkInfo.name,
        default: 'mirror',
        sha256: apkInfo.sha256,
        url: {
          official: apkInfo.url,
          mirror: `https://mirror.ghproxy.com/${apkInfo.url}`,
        },
      },
      iOS: {
        name: ipaInfo.name,
        default: 'mirror',
        sha256: ipaInfo.sha256,
        url: {
          official: ipaInfo.url,
          mirror: `https://mirror.ghproxy.com/${ipaInfo.url}`,
        },
      },
    },
  }

  // Write artifact data to JSON file
  const jsonData = JSON.stringify(artifactData, null, 2)
  await fs.writeFile(`${artifactPath}${version}.json`, jsonData)

  // Symlink latest.json to current version
  await fs.unlink(`${artifactPath}latest.json`, { ignoreENOENT: true }) // Ignore if file doesn't exist
  await fs.symlink(`${version}.json`, `${artifactPath}latest.json`)

  await addAndPush()
}

function buildArtifactPayload({apk,ipa}){

}

async function addAndPush() {
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
