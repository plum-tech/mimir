import { uploadFile } from "./lib/sitmc.js"
import * as path from "path"
import { cli } from '@liplum/cli'
import { searchAndGetAssetInfo } from "./lib/release.js"
import esMain from "es-main"
import { downloadFile, sanitizeNameForUri } from "./lib/utils.js"
import { github } from "./lib/github.js"
import os from "os"
import "dotenv/config"

const main = async () => {
  const args = cli({
    name: 'upload-release-sitmc',
    description: 'Upload release files onto SIT-MC server. Env $SITMC_FILE_TOKEN required.',
    examples: ['node ./upload-release-sitmc.js',],
    require: [],
    options: [],
  })

  const tag = github.release.tag_name
  const apk = await searchAndGetAssetInfo(({ name }) => path.extname(name) === ".apk")
  if (!apk) {
    console.error("Couldn't find .apk file in the release.")
    process.exit(1)
  }

  const apkPath = path.join(os.tmpdir(), apk.name)
  await downloadFile(apk.url, apkPath)
  const res = await uploadFile({
    localFilePath: apkPath,
    remotePath: `${tag}/${sanitizeNameForUri(apk.name)}`,
  })
  console.log(res)
}


if (esMain(import.meta)) {
  main()
}
