import "dotenv/config"
import esMain from "es-main"
import { sendMessageToQQGroup } from "./lib/bot.mjs"
import { cli } from '@liplum/cli'
import { qqGroupNumber } from "./lib/r.mjs"
import { getReleaseNote, getVersion } from "./publish-release.mjs"
import { getLatestReleaseApiUrl, setGithubFromUrl } from "./lib/github.mjs"

const main = async () => {
  const args = cli({
    name: 'bot-notify-release',
    description: 'Bot sends a notification about the latest release in the QQ group. Env $QQBOT_URL required.',
    examples: ['node ./bot-notify-release.mjs [-r <repo>]',],
    require: [],
    options: [{
      name: 'repo',
      alias: "r",
      description: 'The repo that published a release.'
    },],
  })
  if (args.repo) {
    await setGithubFromUrl(getLatestReleaseApiUrl(args.repo))
  }
  const version = getVersion()
  const releaseNote = getReleaseNote()
  const message = `小应生活${version}更新：\n${releaseNote}`
  const result = await sendMessageToQQGroup({
    groupNumber: qqGroupNumber,
    message,
  })
  console.log(result)
}

if (esMain(import.meta)) {
  main()
}
