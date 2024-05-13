import { readFile, writeFile } from "fs/promises"
import * as path from "path"
/**
 *
 * @param {{auth:string,filePath:string, uploadPath:string}} param0
 */
export async function uploadFile({ auth, filePath, uploadPath }) {
  const formData = new FormData()

  const file = new Blob([await readFile(filePath)])
  formData.append('file', file, path.basename(filePath))
  formData.append('path', uploadPath)

  const res = await fetch('http://mua.sitmc.club:32000/upload', {
    method: 'POST',
    headers: {
      Authorization: auth,
    },
    body: formData
  })
  const result = await res.json()
  return result
}
