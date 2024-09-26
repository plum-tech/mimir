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

export const uploadReleaseVersion = async (info) => {
  const res = await versionAPI().post("/release/v", info)
  return res.status
}

export const uploadPreviewVersion = async (info) => {
  const res = await versionAPI().post("/preview/v?android-src-default=fallback", info)
  return res.status
}
