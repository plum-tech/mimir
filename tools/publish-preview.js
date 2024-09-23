import "dotenv/config"
import { getArtifactDownloadUrl } from './lib/sitmc.js'
import esMain from 'es-main'
import { uploadPreviewVersion } from "./lib/backend.js"
import { getLatestTag } from "./lib/git.js"
import { cli } from "@liplum/cli"

const main = async () => {
  const args = cli({
    name: 'publish-preview',
    description: 'Publish the preview and version info onto the back end.',
    examples: ['node ./publish-preview.js',],
    require: [],
    options: [],
  })
  const version = await getLatestTag()
  const info = buildVersionInfo({
    version,
  })

  const result = await uploadPreviewVersion(info)
  console.log(`Uploaded result: ${result}`)
}

const buildVersionInfo = ({ version }) => {
  const fileName = `sitlife-${version}.apk`
  const info = {
    version,
    releaseNote: {
      "zh-Hans": "这是最新的测试版。",
      "en": "It's the latest preview version available.",
    },
    assets: {
      Android: {
        fileName,
        defaultSrc: getArtifactDownloadUrl({ tagName: "mimir-preview", fileName }),
      }
    },
  }
  return info
}

if (esMain(import.meta)) {
  main()
}
