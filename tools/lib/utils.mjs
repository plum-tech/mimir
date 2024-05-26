import fs from "fs"
import { Readable } from "stream"
import { pipeline } from "stream/promises"
/**
 *
 * @param {string} raw
 */
export const sanitizeNameForUri = (raw) => {
  return raw.replace("+", "-")
}


/**
 *
 * @param {string} url
 * @param {string} filePath
 */
export const downloadFile = async (url, filePath) => {
  const res = await fetch(url)

  const s = fs.createWriteStream(filePath)
  // Readable.fromWeb(res.body).pipe(s)
  await pipeline(Readable.fromWeb(res.body), s)

}
