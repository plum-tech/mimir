import { uploadFile } from "./lib/sitmc.js"
import { cli } from '@liplum/cli'
import esMain from "es-main"
import { sanitizeNameForUri } from "./lib/utils.js"
import { getLatestTag } from "./lib/git.js"
import "dotenv/config"

const main = async () => {
  const args = cli({
    name: 'upload-preview-sitmc',
    description: 'Upload preview files onto SIT-MC server. Env $SITMC_FILE_TOKEN required.',
    examples: ['node ./upload-preview-sitmc.js -s <file>',],
    require: ['source'],
    options: [{
      name: 'source',
      alias: "s",
      defaultOption: true,
      description: 'The path of local file to upload to SIT-MC server.'
    }],
  })

  const version = await getLatestTag()
  const filePath = args.source
  const res = await uploadFile({
    localFilePath: filePath,
    remotePath: `mimir-preview/${sanitizeNameForUri(`sitlife-v${version}.apk`)}`,
  })
  console.log(res)
}


if (esMain(import.meta)) {
  main()
}
