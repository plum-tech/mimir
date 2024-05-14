import { readFile } from "fs/promises"
import * as path from "path"
import mime from 'mime'

const prodUrl = "http://mua.sitmc.club:32000/admin"
/**
 *
 * @param {{auth:string,filePath:string, uploadPath:string}} param0
 */
export async function uploadFile({ auth, localFilePath, remotePath }) {
  const formData = new FormData()

  const file = new Blob([await readFile(localFilePath)], { type: mime.getType(localFilePath) })
  formData.append('file', file, path.basename(localFilePath))
  formData.append('path', remotePath)

  const res = await fetch(prodUrl, {
    method: 'PUT',
    headers: {
      Authorization: auth,
    },
    body: formData
  })
  const result = await res.json()
  return result
}
/**
 *
 * @param {{auth:string,deletePath:string}} param0
 */
export async function deleteFile({ auth, remotePath }) {
  const formData = new FormData()
  formData.append('path', remotePath)

  const res = await fetch(prodUrl, {
    method: 'DELETE',
    headers: {
      Authorization: auth,
    },
    body: formData
  })
  const result = await res.json()
  return result
}

/**
 *
 * @param {{tagName:string,fileName:string}} param0
 */
export function getArtifactDownloadUrl({ tagName, fileName }) {
  return `https://temp.sitmc.club/prepare-download/${tagName}/${fileName}`
}
