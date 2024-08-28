import "dotenv/config"
import esMain from "es-main"
import { sendMessageToQQGroup } from "./lib/bot.mjs"
import { cli } from '@liplum/cli'
import { qqGroupNumber } from "./lib/r.mjs"

const main = async () => {
  const args = cli({
    name: 'bot-notify-build',
    description: 'Bot sends a notification about the latest building in the QQ group. Env $QQBOT_URL required.',
    examples: ['node ./bot-notify-build.mjs -v <version>',],
    require: ['version'],
    options: [{
      name: 'version',
      alias: "v",
      description: 'The version of the latest building.'
    },],
  })
  const version = args.version
  const message = `最新测试版${version}已完成构建，Android用户可在群公告中访问最新预览版下载地址；请iOS用户等待发布TestFlight测试`
  const result = await sendMessageToQQGroup({
    groupNumber: qqGroupNumber,
    message,
  })
  console.log(result)
}

if (esMain(import.meta)) {
  main()
}
