import "dotenv/config"
import esMain from "es-main"
import { sendMessageToQQGroup } from "./lib/bot.mjs"
import { cli } from '@liplum/cli'
import { qqGroupNumber } from "./lib/r.mjs"
import { getLatestTag } from "./lib/git.mjs"

const main = async () => {
  const args = cli({
    name: 'bot-notify-build',
    description: 'Bot sends a notification about the latest building in the QQ group. Env $QQBOT_URL required.',
    examples: ['node ./bot-notify-build.mjs -v <version>',],
    require: [],
    options: [{
      name: 'version',
      alias: "v",
      description: 'The version of the latest building. The latest tag will be used by default.'
    },],
  })
  const version = args.version ?? await getLatestTag()
  const message = `最新测试版${version}已完成构建，开发团队正在测试中`
  const result = await sendMessageToQQGroup({
    groupNumber: qqGroupNumber,
    message,
  })
  console.log(result)
}

if (esMain(import.meta)) {
  main()
}
