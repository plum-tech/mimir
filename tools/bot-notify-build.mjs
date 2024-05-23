import esMain from "es-main"
import { sendMessageToQQGroup } from "./lib/bot.mjs"
import { cli } from '@liplum/cli'

async function main() {
  const args = cli({
    name: 'bot-notify-build',
    description: 'Bot sends a notification about the latest building in QQ group.',
    examples: ['node ./bot-notify-build.mjs -u <url> -g <number> -v <version>',],
    require: ["url", 'group_number', 'version'],
    options: [{
      name: 'url',
      alias: "u",
      defaultOption: true,
      description: 'The bot url.'
    }, {
      name: 'group_number',
      alias: "g",
      description: 'The number of QQ group to send notifications.'
    }, {
      name: 'version',
      alias: "v",
      description: 'The version of the latest building.'
    },],
  })

  const botUrl = args.url
  const version = args.version
  const groupNumber = args.group_number
  const message = `最新测试版${version}已完成构建，Android用户可在群公告中访问最新预览版下载地址；请iOS用户等待发布TestFlight测试`
  const result = await sendMessageToQQGroup({ botUrl, groupNumber, message })
  console.log(result)
}

if (esMain(import.meta)) {
  main()
}
