import { github, setGithubFromUrl, getLatestReleaseApiUrl } from "./lib/github.mjs"
import * as path from "path"
import { getArtifactDownloadUrl } from './lib/sitmc.mjs'
import esMain from 'es-main'
import { searchAndGetAssetInfo } from "./lib/release.mjs"
import { uploadReleaseVersion } from "./lib/backend.mjs"
import { cli } from "@liplum/cli"

const main = async () => {
  const args = cli({
    name: 'publish-release',
    description: 'Publish the release and version info onto the back end.',
    examples: ['node ./publish-release.mjs [<repo>]',],
    require: [],
    options: [{
      name: 'repo',
      alias: "r",
      defaultOption: true,
      description: 'The repo to be published onto the back end.'
    },],
  })
  if (args.repo) {
    const url = getLatestReleaseApiUrl(args.repo, "release")
    console.log(url)
    await setGithubFromUrl(url)
  }
  // Get release information from environment variables (GitHub Actions context)
  const info = await prepareVersionInfo()

  const result = await uploadReleaseVersion(info)
  console.log(`Uploaded result: ${result}`)
}

export const prepareVersionInfo = async () => {
  // Get release information from environment variables (GitHub Actions context)
  const version = getVersion()
  const releaseTime = getPublishTime()
  const releaseNote = getReleaseNote()
  console.log(version, releaseTime)

  const apk = await searchAndGetAssetInfo(({ name }) => path.extname(name) === ".apk")

  // Generate artifact data
  const artifactPayload = buildVersionInfo({
    version,
    tagName: github.release.tag_name,
    releaseTime,
    releaseNote,
    apk,
  })
  return artifactPayload
}

export const getVersion = () => {
  // remove leading 'v'
  return github.release.tag_name.slice(1)
}

const extractMarkdownSection = (startLine, endLine) => {
  const text = github.release.body
  const start = text.indexOf(startLine)
  const end = text.indexOf(endLine)
  if (start === -1 || end === -1) {
    throw new Error(`Release notes section between "${startLine}" and "${endLine}" not found`)
  }
  let section = text.substring(start + `${startLine}\n`.length, end).trim()
  section = section.replace(/^\s*|\s*$/g, '')
  section = section.trim()
  return section
}

export const getReleaseNote = () => {
  const en = extractMarkdownSection('## Changes', '## 更改')
  const zh_Hans = extractMarkdownSection('## 更改', '## How to download')

  return {
    ["en"]: en,
    ["zh-Hans"]: zh_Hans,
  }
}

export const getPublishTime = () => {
  return new Date(github.release.published_at)
}

const buildVersionInfo = ({ version, tagName, releaseTime, releaseNote, apk }) => {
  const androidMarketUrl = "market://details?id=life.mysit.sit_life"
  const info = {
    version,
    time: releaseTime,
    releaseNote,
    importance: "normal",
    delayInMinute: 7 * 24 * 60,
    assets: {
      Android: {
        fileName: apk.name,
        defaultSrc: getArtifactDownloadUrl({ tagName, fileName: apk.name }),
        src: {
          "com.heytap.market": androidMarketUrl,
          "com.hihonor.appmarket": androidMarketUrl,
          "com.huawei.appmarket": androidMarketUrl,
          "com.huawei.localBackup": androidMarketUrl,
          "com.huawei.browser": androidMarketUrl,
          "com.bbk.appstore": androidMarketUrl,
          "com.xiaomi.market": androidMarketUrl,
          "com.miui.packageinstaller": androidMarketUrl
        }
      }
    },
  }
  return info
}

if (esMain(import.meta)) {
  main()
}
