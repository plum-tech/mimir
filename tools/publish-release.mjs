import { github, getGitHubMirrorDownloadUrl, setGithubFromUrl, getLatestReleaseApiUrl } from "./lib/github.mjs"
import * as path from "path"
import { getArtifactDownloadUrl } from './lib/sitmc.mjs'
import esMain from 'es-main'
import { searchAndGetAssetInfo } from "./lib/release.mjs"
import { modifyDocsRepoAndPush } from './lib/mimir-docs.mjs'
import { cli } from "@liplum/cli"

const main = async () => {
  const args = cli({
    name: 'publish-release',
    description: 'Publish the release onto mimir-docs.',
    examples: ['node ./publish-release.mjs [<repo>]',],
    require: [],
    options: [{
      name: 'repo',
      alias: "r",
      defaultOption: true,
      description: 'The repo to be published onto mimir-docs.'
    },],
  })
  if (args.repo) {
    const url = getLatestReleaseApiUrl(args.repo)
    console.log(url)
    await setGithubFromUrl(url)
  }
  // Get release information from environment variables (GitHub Actions context)
  const version = getVersion()
  const artifactPayload = await prepareArtifactPayload()

  await modifyDocsRepoAndPush({ version, payload: artifactPayload })
}

export const prepareArtifactPayload = async () => {
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
  return artifactPayload
}

export const getVersion = () => {
  // remove leading 'v'
  return github.release.tag_name.slice(1)
}

export const getReleaseNote = () => {
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

export const getPublishTime = () => {
  return new Date(github.release.published_at)
}

const buildArtifactPayload = ({ version, tagName, releaseTime, releaseNote, apk, ipa }) => {
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

export const validateArtifactPayload = (payload) => {
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
