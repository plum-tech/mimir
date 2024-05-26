import { uploadFile } from "./lib/sitmc.mjs"
import * as path from "path"
import { cli } from '@liplum/cli'
import { searchAndGetAssetInfo, github } from "./lib/release.mjs"
import esMain from "es-main"
import { downloadFile, sanitizeNameForUri } from "./lib/utils.mjs"
import os from "os"

const main = async () => {
  const args = cli({
    name: 'upload-release-sitmc',
    description: 'Upload release files onto SIT-MC server.',
    examples: ['node ./upload-release-sitmc.mjs -k <auth>',],
    require: ["auth"],
    options: [{
      name: 'auth',
      alias: "k",
      defaultOption: true,
      description: 'The authentication key of SIT-MC server.'
    }],
  })

  const auth = args.auth
  const tag = github.release.tag_name
  const apk = await searchAndGetAssetInfo(({ name }) => path.extname(name) === ".apk")
  if (!apk) {
    console.error("Couldn't find .apk file in the release.")
    process.exit(1)
  }

  const apkPath = path.join(os.tmpdir(), apk.name)
  await downloadFile(apk.url, apkPath)
  const res = await uploadFile({
    auth,
    localFilePath: apkPath,
    remotePath: `${sanitizeNameForUri(tag)}/${sanitizeNameForUri(apk.name)}`,
  })
  console.log(res)
}


if (esMain(import.meta)) {
  main()
}
