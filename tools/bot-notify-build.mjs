import { sendMessageToQQGroup } from "./bot.mjs"

async function main() {
  const botUrl = process.argv[2]
  const groupNumber = process.argv[3]
  const version = process.argv[4]
  const message = `最新测试版${version}已完成构建，请Android用户等待开发者上传.apk文件到群文件；请iOS用户等待发布TestFlight测试`
  const result = await sendMessageToQQGroup({ botUrl, groupNumber, message })
  console.log(result)
}

main()
