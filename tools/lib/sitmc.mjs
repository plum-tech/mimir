import { readFile } from "fs/promises"
import * as path from "path"
import mime from 'mime'
import { sanitizeNameForUri } from "./utils.mjs"

const prodUrl = "https://temp.sitmc.club"
const debugUrl = "http://127.0.0.1:5000"
const url = prodUrl
/**
 *
 * @param {{auth:string,filePath:string, uploadPath:string}} param0
 */
export async function uploadFile({ auth, localFilePath, remotePath }) {
  const formData = new FormData()

  const file = new Blob([await readFile(localFilePath)], { type: mime.getType(localFilePath) })
  formData.append('file', file, path.basename(localFilePath))
  formData.append('path', remotePath)

  const res = await fetch(`${url}/admin`, {
    method: 'PUT',
    headers: {
      Authorization: auth,
    },
    body: formData
  })
  if (res.ok) {
    return await res.json()
  } else {
    return await res.text()
  }
}
/**
 *
 * @param {{auth:string,deletePath:string}} param0
 */
export async function deleteFile({ auth, remotePath }) {
  const formData = new FormData()
  formData.append('path', remotePath)

  const res = await fetch(`${url}/admin`, {
    method: 'DELETE',
    headers: {
      Authorization: auth,
    },
    body: formData
  })
  if (res.ok) {
    return await res.json()
  } else {
    return await res.text()
  }
}

/**
 *
 * @param {{tagName:string,fileName:string}} param0
 */
export function getArtifactDownloadUrl({ tagName, fileName }) {
  return `https://temp.sitmc.club/prepare-download/${sanitizeNameForUri(tagName)}/${sanitizeNameForUri(fileName)}`
}
