import { readFile } from "fs/promises"
import * as path from "path"
import mime from 'mime'
import { sanitizeNameForUri } from "./utils.js"
import axios from "axios"
import env from "@liplum/env"
import lateinit from "@liplum/lateinit"
const io = lateinit(() => {
  const auth = env("SITMC_TEMP_SERVER_AUTH").string()
  return axios.create({
    // baseURL: "http://127.0.0.1:5000",
    baseURL: "https://temp.sitmc.club",
    headers: {
      Authorization: auth,
    },
  })
})

/**
 *
 * @param {{filePath:string, uploadPath:string}} param0
 */
export async function uploadFile({ localFilePath, remotePath }) {
  const formData = new FormData()

  const file = new Blob([await readFile(localFilePath)], { type: mime.getType(localFilePath) })
  formData.append('file', file, path.basename(localFilePath))
  formData.append('path', remotePath)

  const res = await io().put("/admin", formData, {
    onUploadProgress: (e) => {
      console.log(`${(e.progress * 100).toFixed(2)}%`)
      // bar.update(e.progress)
    }
  })
  // bar.stop()

  return res.data
}
/**
 *
 * @param {{deletePath:string}} param0
 */
export async function deleteFile({ remotePath }) {
  const formData = new FormData()
  formData.append('path', remotePath)

  const res = await io().delete("/admin", formData)
  return res.data
}

/**
 *
 * @param {{tagName:string,fileName:string}} param0
 */
export function getArtifactDownloadUrl({ folder, fileName }) {
  return `https://temp.sitmc.club/prepare-download/${folder}/${sanitizeNameForUri(fileName)}`
}
