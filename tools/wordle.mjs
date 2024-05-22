import esMain from "es-main"
import * as fs from "fs/promises"
import * as p from "path"
import splitLines from 'split-lines'
import mime from 'mime'
import { parse } from 'csv-parse/sync'
import { app } from '@liplum/cli'

export async function main(argv) {
  const args = app({
    name: "Mimir tool - Wordle",
    description: "For processing Wordle vocabulary.",
    commands: [{
      name: 'extract',
      description: 'Extract Wordle vocabulary from file.',
      examples: ['extract <path>',],
      require: ['path'],
      options: [{
        name: 'path',
        alias: "p",
        defaultOption: true,
        description: 'The file path to be converted, or a directory containing all files to be converted'
      },],
    }, {
      name: 'merge',
      description: 'Merge multiple vocabularies into a single vocabulary.',
      examples: ['merge <path1> [<path2>] -o all.json',],
      require: ['paths'],
      options: [{
        name: 'paths',
        alias: "p",
        multiple: true,
        defaultOption: true,
        description: 'All Wordle vocabularies to be merged, or a directory containing all vocabularies to be merged.'
      }, {
        name: 'output',
        alias: "o",
        defaultValue: "all.json",
        description: 'The merged output file.'
      },],
    }, {
      name: 'clean',
      description: 'The file path to be cleaned up, or a directory containing all files to be cleaned up.',
      examples: ['clean <path>',],
      require: ['path'],
      options: [{
        name: 'path',
        alias: "p",
        defaultOption: true,
        description: 'The file path to be cleaned up, or a directory containing all files to be cleaned up.'
      },],
    },]
  }, { argv })
  try {
    switch (args._command) {
      case "extract":
        await extract(args)
        break
      case "merge":
        await merge(args)
        break
      case "clean":
        await clean(args)
        break
    }
  } catch (e) {
    console.error(e)
  }
}

async function extract(args) {
  const filePath = args.path
  await fs.access(filePath, fs.constants.R_OK)
  const stat = await fs.stat(filePath)
  if (stat.isFile()) {
    await extractFromFileAndSave(filePath)
  } else if (stat.isDirectory()) {
    for (const file of await fs.readdir(filePath)) {
      const path = p.join(filePath, file)
      const ext = p.extname(path)
      if (ext == ".json") continue
      if (ext != ".txt") continue
      await extractFromFileAndSave(path)
    }
  }
}

async function extractFromFileAndSave(path) {
  const vocabulary = await extractFromFile(path)
  const newContent = JSON.stringify(vocabulary)
  const newPath = p.join(p.dirname(path), `${p.basename(path, p.extname(path)).toLocaleLowerCase()}.json`.replace(" ", "-"))
  await fs.writeFile(newPath, newContent)
}

async function merge(args) {
  const paths = args.paths
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
  const output = args.output
  const mergedContent = JSON.stringify(merged)
  await fs.writeFile(output, mergedContent)
}

async function clean(args) {
  const path = args.path
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
 * @returns {Promise<string[]>}
 */
async function extractFromFile(path) {
  const content = await fs.readFile(path)
  const contentType = mime.getType(path)
  const vocabulary = extractVocabulary(content, contentType)
  return vocabulary
}

/**
 *
 * @param {Buffer} content
 * @param {string?} contentType
 * @returns {string[]}
 */
function extractVocabulary(content, contentType) {
  switch (contentType) {
    case "text/plain":
      return extractVocabularyFromTextPlain(content.toString("utf8"))
    case "text/csv":
      return extractVocabularyFromCsv(content.toString("utf8"))
  }
  throw new Error("Unkown vocabulary file type: " + contentType)
}
/**
 *
 * @param {string} content
 * @returns {string[]}
 */
function extractVocabularyFromTextPlain(content) {
  const lines = splitLines(content)
  const words = new Set()
  for (const line of lines) {
    const vowelStart = line.indexOf('[')
    const word = line.substring(0, vowelStart == -1 ? undefined : vowelStart).trim().toLocaleUpperCase()
    if (validateWord(word)) {
      words.add(word)
    }
  }
  return [...words]
}
/**
 *
 * @param {string} content
 * @returns {string[]}
 */
function extractVocabularyFromCsv(content) {
  const records = parse(content, { bom: true })
  if (!records.length) throw new Error("no words in csv file")
  const template = records[0]
  const wordIndex = findWordIndexInCsv(template)
  if (wordIndex < 0) throw new Error("no word column in csv file")
  const words = new Set()
  for (const row of records) {
    const word = row[wordIndex]
    if (validateWord(word)) {
      words.add(word)
    }
  }
  return [...words]
}

/**
 *
 * @param {string[]} row
 */
function findWordIndexInCsv(row) {
  for (let i = 0; i < row.length; i++) {
    const cell = row[i]
    if (/^[a-zA-Z]+$/.test(cell)) {
      return i
    }
  }
  return -1
}

if (esMain(import.meta)) {
  main(process.argv)
}
