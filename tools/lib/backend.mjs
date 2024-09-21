import env from "@liplum/env"
import lateinit from "@liplum/lateinit"
import axios from "axios"

const versionAPI = lateinit(() => {
  const token = env("MIMIR_VERSION_TOKEN").string()
  return axios.create({
    baseURL: "https://g.mysit.life/v1",
    headers: {
      Cookie: `MIMIR_VERSION_ADMIN_TOKEN=${token};`,
    }
  })
})

export const uploadVersion = async (info) => {
  const res = await versionAPI().post("/v", info)
  return res.status
}
