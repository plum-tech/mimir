import esMain from "es-main"
import * as fs from "fs/promises"
import * as p from "path"
import splitLines from 'split-lines'
import commandLineArgs from "command-line-args"
import commandLineUsage from "command-line-usage"

const usage = commandLineUsage([{
  header: "Mimir tool - WORDLE",
  content: "For processing WORDLE vocabulary."
}, {
  header: "Command List",
  content: [{
    name: "help", summary: "Display help information.",
  }, {
    name: "extract", summary: "Extract WORDLE vocabulary from file.",
  }, {
    name: "merge", summary: "Merge multiple vocabularies into a single vocabulary.",
  }, {
    name: "clean", summary: "Clean up a vocabulary file.",
  },]
}, {
  header: "Command: extract",
  optionList: [{
    name: "path", defaultOption: true, alias: "p",
    description: "The file path to be converted, or a directory containing all files to be converted."
  }]
}, {
  header: "Command: merge",
  optionList: [{
    name: "paths", defaultOption: true, alias: "p", multiple: true, defaultValue: "all.json",
    description: "All WORDLE vocabularies to be merged, or a directory containing all vocabularies to be merged."
  }]
}, {
  header: "Command: clear",
  optionList: [{
    name: "path", defaultOption: true, alias: "p",
    description: "The file path to be cleaned up, or a directory containing all files to be cleaned up."
  }]
}])

export async function main(argv) {
  const mainCmd = commandLineArgs([
    { name: "cmd", defaultOption: true },
  ], { stopAtFirstUnknown: true, argv })

  const cmdArgv = mainCmd._unknown || []
  try {
    switch (mainCmd.cmd) {
      case "extract":
        await extract(cmdArgv)
        break
      case "merge":
        await merge(cmdArgv)
        break
      case "clean":
        await clean(cmdArgv)
        break
      default:
        console.log(usage)
        break
    }
  } catch (e) {
    console.error(e)
    console.log(usage)
  }
}

async function extract(argv) {
  const cmd = commandLineArgs([
    { name: "path", alias: "p", type: String, defaultOption: true }
  ], { argv })

  const filePath = cmd.argv[0]
  await fs.access(filePath, fs.constants.R_OK)
  const stat = await fs.stat(filePath)
  if (stat.isFile()) {
    await extractFromFile(filePath)
  } else if (stat.isDirectory()) {
    for (const file of await fs.readdir(filePath)) {
      const path = p.join(filePath, file)
      const ext = p.extname(path)
      if (ext == ".json") continue
      if (ext != ".txt") continue
      await extractFromFile(path)
    }
  }
}

async function merge(argv) {
  const cmd = commandLineArgs([
    { name: "paths", alias: "p", type: String, multiple: true, defaultOption: true },
    { name: "output", alias: "o", type: String, defaultValue: "all.json" },
  ], { argv })
  const paths = cmd.paths
  const vocabularies = []
  for (const path of paths) {
    await fs.access(path, fs.constants.R_OK)
    const stat = await fs.stat(path)
    if (stat.isDirectory()) {
      for (const file of await fs.readdir(path)) {
        const filePath = p.join(path, file)
        const vocabulary = await loadVocabularyFile(filePath)
        vocabularies.push(vocabulary)
      }
    } else if (stat.isFile()) {
      const vocabulary = await loadVocabularyFile(path)
      vocabularies.push(vocabulary)
    }
  }
  const merged = [...mergeVocabularies(vocabularies)]
  const output = cmd.output
  const mergedContent = JSON.stringify(merged)
  await fs.writeFile(output, mergedContent)
}

async function clean(argv) {
  const cmd = commandLineArgs([
    { name: "path", alias: "p", type: String, defaultOption: true },
  ], { argv })
  const path = cmd.path
  await fs.access(path, fs.constants.R_OK, fs.constants.W_OK)
  const stat = await fs.stat(path)
  if (stat.isDirectory()) {
    for (const file of await fs.readdir(path)) {
      const filePath = p.join(path, file)
      await cleanVocabularyFile(filePath)
    }
  } else if (stat.isFile()) {
    await cleanVocabularyFile(path)
  }
}

/**
 *
 * @param {string} word
 * @returns {boolean}
 */
export function validateWord(word) {
  if (word.length != 5) return false
  if (!(/^[a-zA-Z]+$/.test(word))) return false
  return true
}

/**
 *
 * @param {Array<string[]>} vocabularies
 * @returns {Set<string>}
 */
function mergeVocabularies(vocabularies) {
  const set = new Set()
  for (const vocabluary of vocabularies) {
    for (let word of vocabluary) {
      word = word.toLocaleUpperCase()
      if (validateWord(word)) {
        set.add(word)
      }
    }
  }
  return set
}

/**
 *
 * @param {string} path
 * @returns {Promise<string[]>}
 */
async function loadVocabularyFile(path) {
  let json
  try {
    const text = await fs.readFile(path, { encoding: "utf8" })
    json = JSON.parse(text)
  } catch {
    throw new Error("Not a vocabluary file")
  }
  if (!Array.isArray(json)) {
    throw new Error("Not a vocabluary file")
  }
  const words = []
  for (let word of json) {
    word = word.toLocaleUpperCase()
    if (validateWord(word)) {
      words.push(word)
    }
  }
  return words
}

/**
 *
 * @param {string} path
 */
async function cleanVocabularyFile(path) {
  const vocabluary = await loadVocabularyFile(path)
  const json = JSON.stringify(vocabluary)
  await fs.writeFile(path, json)
}

/**
 *
 * @param {string} path
 */
async function extractFromFile(path) {
  const text = await fs.readFile(path, { encoding: "utf8" })
  const lines = splitLines(text)
  const words = extractVocabulary(lines)
  const newContent = JSON.stringify(words)
  const newPath = p.join(p.dirname(path), `${p.basename(path, ".txt").toLocaleLowerCase()}.json`.replace(" ", "-"))
  await fs.writeFile(newPath, newContent)
}

/**
 *
 * @param {[string]} lines
 * @returns {[string]}
 */
function extractVocabulary(lines) {
  const words = []
  for (const line of lines) {
    const vowelStart = line.indexOf('[')
    const word = line.substring(0, vowelStart == -1 ? undefined : vowelStart).trim().toLocaleUpperCase()
    if (validateWord(word)) {
      words.push(word)
    }
  }
  return words
}



if (esMain(import.meta)) {
  main(process.argv)
}
