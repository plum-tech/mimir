import { uploadFile } from "./lib/sitmc.mjs"
import * as path from "path"
import { cli } from '@liplum/cli'
import esMain from "es-main"
import "dotenv/config"

const main = async () => {
  const args = cli({
    name: 'upload-sitmc',
    description: 'Upload files onto SIT-MC server. Env $SITMC_FILE_TOKEN required.',
    examples: ['node ./upload-sitmc.mjs -s <file> -d <path>',],
    require: ['source'],
    options: [{
      name: 'source',
      alias: "s",
      defaultOption: true,
      description: 'The path of local file to upload to SIT-MC server.'
    }, {
      name: 'destination',
      alias: "d",
      description: 'The server path where to save the uploaded file.'
    },],
  })

  const filePath = args.source
  const remotePath = args.destination ?? path.join(path.basename(path.dirname(filePath)), path.basename(filePath))
  const res = await uploadFile({
    localFilePath: filePath,
    remotePath: remotePath,
  })
  console.log(res)
}


if (esMain(import.meta)) {
  main()
}
