import { readFile } from "fs/promises"
import * as path from "path"
import mime from 'mime'
import { sanitizeNameForUri } from "./utils.mjs"
import axios from "axios"
import env from "@liplum/env"
import ProgressBar from 'progress'
const auth = env("SITMC_TEMP_SERVER_AUTH").string()
const io = axios.create({
  // baseURL: "http://127.0.0.1:5000",
  baseURL: "https://temp.sitmc.club",
  headers: {
    Authorization: auth,
  },
  timeout: 120 * 1000, //ms
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

  const bar = new ProgressBar('[:bar] :percent :rate/bps :etas', {
    complete: '=',
    incomplete: ' ',
    width: 20,
    total: 10,
  })
  const res = await io.put("/admin", formData, {
    onUploadProgress: (e) => {
      const pct = Math.round((e.loaded * 100) / e.total)
      bar.update(pct)
    }
  })

  return res.data
}
/**
 *
 * @param {{deletePath:string}} param0
 */
export async function deleteFile({ remotePath }) {
  const formData = new FormData()
  formData.append('path', remotePath)

  const res = await io.delete("/admin", formData)
  return res.data
}

/**
 *
 * @param {{tagName:string,fileName:string}} param0
 */
export function getArtifactDownloadUrl({ tagName, fileName }) {
  return `https://temp.sitmc.club/prepare-download/${tagName}/${sanitizeNameForUri(fileName)}`
}
