import { simpleGit } from 'simple-git'
import { context } from "@actions/github"

export const git = simpleGit()
export const github = context

/**
 * Extract the version and build number from a full version string like "v1.0.0+1" or "2.0.0+18"
 * @param {string} tag
 * @returns {[string, number]}
 */
export const extractVersionAndBuildNumberFromTag = (tag) => {
  const versionMatch = tag.match(/(\d+.\d+.\d+)/)
  const buildNumberMatch = tag.match(/\d+.\d+.\d+(\+\d+)/)
  const version = versionMatch[1]
  if (!version) {
    throw new Error(`Could not find version in tag "${tag}"`)
  }
  const buildNumber = buildNumberMatch ? parseInt(buildNumberMatch[1].slice(1)) : 0
  return [version, buildNumber]
}

/**
 * Get the largest version and build number from current git repository
 * @returns {Promise<[string, int]>}
 */
export const getLargestTag = async () => {
  const tags = await git.tags()
  // in ascending order
  const versionInfos = tags.all.map(tag => extractVersionAndBuildNumberFromTag(tag)).sort((a, b) => a[1] - b[1])
  return versionInfos[versionInfos.length - 1]
}


export const getGitHubMirrorDownloadUrl = (url) => {
  return `https://mirror.ghproxy.com/${url}`
}
