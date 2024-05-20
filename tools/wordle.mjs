import esMain from "es-main"
import * as fs from "fs/promises"
import * as p from "path"
import splitLines from 'split-lines'
async function main() {
  const filePath = process.argv[2]
  fs.access(filePath, fs.constants.R_OK)
  const stat = await fs.stat(filePath)
  if (stat.isFile()) {
    await convertFile(filePath)
  } else if (stat.isDirectory()) {
    for (const file of await fs.readdir(filePath)) {
      const path = p.join(filePath, file)
      const ext = p.extname(path)
      if (ext == ".json") continue
      if (ext != ".txt") continue
      await convertFile(path)
    }
  }
}

/**
 *
 * @param {string} path
 */
async function convertFile(path) {
  const text = await fs.readFile(path, { encoding: "utf8" })
  const lines = splitLines(text)
  const len2words = extract(lines, { minLen: 5, maxLen: 5 })
  const newContent = JSON.stringify(len2words[5])
  const newPath = p.join(p.dirname(path), `${p.basename(path, ".txt").toLocaleLowerCase()}.json`.replace(" ", "-"))
  await fs.writeFile(newPath, newContent)
}

/**
 *
 * @param {[string]} lines
 * @param {{minLen:number,maxLen:number}} param1
 * @return {Record<number,[string]>}
 */
function extract(lines, { minLen, maxLen }) {
  const len2words = {}
  for (const line of lines) {
    const vowelStart = line.indexOf('[')
    const word = line.substring(0, vowelStart == -1 ? undefined : vowelStart).trim().toLocaleUpperCase()
    const len = word.length
    if (minLen <= len && len <= maxLen) {
      const words = len2words[len] ??= []
      words.push(word)
    }
  }
  return len2words
}



if (esMain(import.meta)) {
  main()
}
