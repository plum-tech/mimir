import { context } from "@actions/github"
import axios from "axios"

export { context } from "@actions/github"
export var github = context.payload

export const setGitHub = (ctx, key) => {
  github = { [key]: ctx }
}

export const setGithubFromUrl = async (url, key) => {
  const res = await axios.get(url)
  setGitHub(res.data, key)
}

export const getLatestReleaseApiUrl = (repo) => {
  return `https://api.github.com/repos/${repo}/releases/latest`
}

export const getGitHubMirrorDownloadUrl = (url) => {
  return `https://mirror.ghproxy.com/${url}`
}
