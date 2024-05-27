import esMain from "es-main"
import { cli } from '@liplum/cli'
import fs from "fs/promises"
import { modifyDocsRepoAndPush } from "./publish-release.mjs"

async function main() {
  const args = cli({
    name: 'deploy-docs',
    description: 'Deploy the documentation pages',
    examples: ['node ./deploy-docs v1.0.0+1',],
    require: ["version", ["json", "path"]],
    options: [{
      name: 'version',
      alias: "v",
      defaultOption: true,
      description: 'The bot url.'
    }, {
      name: 'json',
      description: 'The version info in JSON.'
    }, {
      name: 'path',
      description: 'The file path of a version info in JSON.'
    },],
  })
  let json = args.json ? JSON.parse(args.json) : undefined
  if (args.path) {
    const content = await fs.readFile(args.path, { encoding: 'utf8' })
    json = JSON.parse(content)
  }
  const version = args.version
  modifyDocsRepoAndPush({ version, payload: json })
}

if (esMain(import.meta)) {
  main()
}
