import { uploadFile } from "./sitmc.mjs"
import * as path from "path"
import { cli } from '@liplum/cli'
import esMain from "es-main"

async function main() {
  const args = cli({
    name: 'upload-sitmc',
    description: 'Upload files onto SIT-MC server.',
    examples: ['node ./upload-sitmc.mjs -k <auth> -s <file> -d <path>',],
    require: ["auth", 'source'],
    options: [{
      name: 'auth',
      alias: "k",
      description: 'The authentication key of SIT-MC server.'
    }, {
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

  const auth = args.auth
  const filePath = args.source
  const remotePath = args.destination ?? path.join(path.basename(path.dirname(filePath)), path.basename(filePath))
  const res = await uploadFile({
    auth,
    localFilePath: filePath,
    remotePath: remotePath,
  })
  console.log(res)
}


if (esMain(import.meta)) {
  main()
}
