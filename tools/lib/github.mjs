import { context } from "@actions/github"

export { context } from "@actions/github"
export const github = context.payload

export const getGitHubMirrorDownloadUrl = (url) => {
  return `https://mirror.ghproxy.com/${url}`
}
