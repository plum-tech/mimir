import esMain from "es-main"
import { sendMessageToQQGroup } from "./lib/bot.mjs"
import { cli } from '@liplum/cli'
import { qqGroupNumber } from "./r.mjs"
import { getReleaseNote } from "./publish-release.mjs"

async function main() {
  const args = cli({
    name: 'bot-notify-release',
    description: 'Bot sends a notification about the latest release in the QQ group.',
    examples: ['node ./bot-notify-release.mjs <url> -v <version>',],
    require: ["url"],
    options: [{
      name: 'url',
      alias: "u",
      defaultOption: true,
      description: 'The bot url.'
    },],
  })
  const botUrl = args.url
  const releaseNote = getReleaseNote()
  const result = await sendMessageToQQGroup({
    botUrl,
    groupNumber: qqGroupNumber,
    message: releaseNote,
  })
  console.log(result)
}

if (esMain(import.meta)) {
  main()
}
