import env from "@liplum/env"
import axios from "axios"

const botUrl = env("QQBOT_URL").string()

/**
 *
 * @param {{botUrl: string,token:string, groupNumber:string,message:string}} param0
 * @returns
 */
export const sendMessageToQQGroup = async ({ groupNumber, message }) => {
  const url = new URL(botUrl)
  url.searchParams.append("group_id", groupNumber)
  url.searchParams.append("message", message)

  const res = await axios.get(url)
  return res.data
}
