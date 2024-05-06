import { execSync } from 'child_process' // For shell commands
import * as fs from 'fs/promises' // For file system operations
import * as https from 'https' // For downloading files

const gitUrl = 'https://github.com/Amazefcc233/mimir-docs'
const deployPath = '~/deploy'
const artifactPath = 'artifact/'

async function main() {
  // Clone repository
  execSync(`git clone --single-branch --branch main ${gitUrl} ${deployPath}`)

  // Change directory
  process.chdir(deployPath)

  // Get release information from environment variables (assuming GitHub Actions context)
  const version = process.env.GITHUB_EVENT_RELEASE_TAG_NAME.slice(1) // remove leading 'v'
  const releaseTime = convertReleaseTime(process.env.GITHUB_EVENT_RELEASE_PUBLISHED_AT)
  const releaseNote = await getReleaseNote(process.env.GITHUB_EVENT_RELEASE_BODY)

  // Get asset information
  const [apkInfo, ipaInfo] = await Promise.all([getAssetInfo('apk'), getAssetInfo('ipa')])

  // Configure git
  execSync('git config --global user.name "github-actions[bot]"')
  execSync('git config --global user.email "github-actions[bot]@users.noreply.github.com"')

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

  // Git operations
  execSync('git add .')
  execSync(`git commit -m "Release New Version: ${version}"`)
  execSync(`git push "git@github.com:Amazefcc233/mimir-docs" main:main`)
}

async function convertReleaseTime(releaseTimeString) {
  const releaseTime = new Date(releaseTimeString.replace('T', ' ').replace('Z', ''))
  releaseTime.setHours(releaseTime.getHours() - 8) // Adjust for 8 hours difference
  return releaseTime.toISOString().slice(0, 19).replace('T', ' ') // Format: YYYY-MM-DD HH:MM:SS
}

async function getReleaseNote(body) {
  const lines = body.split('\n')
  const startIndex = lines.findIndex(line => line.startsWith('## 更改'))
  const endIndex = lines.findIndex(line => line.startsWith('## How to download'))
  return lines.slice(startIndex + 1, endIndex - 1).join('\n').trim()
}

async function getAssetInfo(type) {
  const asset = process.env[`GITHUB_EVENT_RELEASE_ASSETS_${type.toUpperCase()}_0`]
  if (!asset) {
    return { name: '', sha256: '', url: '' }
  }
  const url = asset.browser_download_url
  const sha256 = url ? await downloadAndHash(url) : ''
  return { name: asset.name, sha256, url }
}

async function downloadAndHash(url) {
  const response = await fetch(url)
  const chunks = []
  for await (const chunk of response.body) {
    chunks.push(chunk)
  }
  const buffer = Buffer.concat(chunks)
  const hash = crypto.createHash('sha256').update(buffer).digest('hex')
  return hash
}

main().catch(error => {
  console.error(error)
  process.exit(1)
})
