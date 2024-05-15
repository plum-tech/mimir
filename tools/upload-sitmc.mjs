import { uploadFile } from "./sitmc.mjs"
import * as path from "path"

async function main() {
  const auth = process.env.SITMC_TEMP_SERVER_AUTH
  const filePath = process.argv[2]
  const remotePath = process.argv[3] ?? path.join(path.basename(path.dirname(filePath)), path.basename(filePath))
  const res = await uploadFile({
    auth,
    localFilePath: filePath,
    remotePath: remotePath,
  })
  console.log(res)
}

main()
