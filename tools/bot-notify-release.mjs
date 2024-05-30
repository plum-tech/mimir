import esMain from "es-main"
import { sendMessageToQQGroup } from "./lib/bot.mjs"
import { cli } from '@liplum/cli'
import { qqGroupNumber } from "./r.mjs"
import { getReleaseNote, getVersion } from "./publish-release.mjs"
import { getLatestReleaseApiUrl, setGithubFromUrl } from "./lib/github.mjs"

const main = async () => {
  const args = cli({
    name: 'bot-notify-release',
    description: 'Bot sends a notification about the latest release in the QQ group.',
    examples: ['node ./bot-notify-release.mjs <url> [-r <repo>]',],
    require: ["url"],
    options: [{
      name: 'url',
      alias: "u",
      defaultOption: true,
      description: 'The bot url.'
    }, {
      name: 'repo',
      alias: "r",
      description: 'The repo that published a release.'
    },],
  })
  if (args.repo) {
    await setGithubFromUrl(getLatestReleaseApiUrl(args.repo))
  }
  const botUrl = args.url
  const version = getVersion()
  const releaseNote = getReleaseNote()
  const message = `小应生活${version}更新：\n${releaseNote}`
  const result = await sendMessageToQQGroup({
    botUrl,
    groupNumber: qqGroupNumber,
    message,
  })
  console.log(result)
}

if (esMain(import.meta)) {
  main()
}
