import { context } from "@actions/github"

export { context } from "@actions/github"
export var github = context.payload

export const setGitHub = (ctx, key) => {
  github = { [key]: ctx }
}

export const setGithubFromUrl = async (url, key) => {
  const res = await fetch(url)
  const payload = await res.json()
  setGitHub(payload, key)
}

export const getLatestReleaseApiUrl = (repo) => {
  return `https://api.github.com/repos/${repo}/releases/latest`
}

export const getGitHubMirrorDownloadUrl = (url) => {
  return `https://mirror.ghproxy.com/${url}`
}
