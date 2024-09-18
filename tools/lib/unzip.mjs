import { pipeline } from 'stream/promises'
import yauzl from 'yauzl-promise'
import * as fsp from "fs/promises"
import * as fs from "fs"
import * as p from "path"

export const unzipFile = async (zipFilePath, outputDirectory) => {
  await fsp.mkdir(outputDirectory, { recursive: true })
  const zip = await yauzl.open(zipFilePath)
  try {
    for await (const entry of zip) {
      const path = p.join(outputDirectory, entry.filename)
      if (entry.filename.endsWith('/')) {
        await fsp.mkdir(path, { recursive: true })
        console.log(`Created directory: ${path}`)
      } else {
        const readStream = await entry.openReadStream()
        const writeStream = fs.createWriteStream(path)
        await pipeline(readStream, writeStream)
        console.log(`Unzipped file: ${path}`)
      }
    }
  } finally {
    await zip.close()
  }
}
