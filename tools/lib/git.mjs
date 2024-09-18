import { simpleGit } from 'simple-git'

/**
 * The git on current working directory.
 */
export const git = simpleGit()

export const gitOf = simpleGit

/**
 * Extract the version and build number from a full version string like "v1.0.0+1" or "2.0.0+18"
 * @param {string} tag
 */
export const extractVersionAndBuildNumberFromTag = (tag) => {
  const versionMatch = tag.match(/(\d+.\d+.\d+)/)
  const buildNumberMatch = tag.match(/\d+.\d+.\d+(\+\d+)/)
  const version = versionMatch[1]
  if (!version) {
    throw new Error(`Could not find version in tag "${tag}"`)
  }
  const buildNumber = buildNumberMatch ? parseInt(buildNumberMatch[1].slice(1)) : 0
  return { version, buildNumber }
}

/**
 * Get the largest version and build number from current git repository
 * @param {string?} version
 * @returns {Promise<{version:string,buildNumber:number}?>}
 */
export const getLargestTag = async (version) => {
  const tags = await git.tags()
  // in ascending order
  let versionInfos = tags.all.map(tag => extractVersionAndBuildNumberFromTag(tag))
  if (version) {
    versionInfos = versionInfos.filter((info) => info.version === version)
  }
  versionInfos.sort((a, b) => a.buildNumber - b.buildNumber)
  if (versionInfos.length === 0) return
  return versionInfos[versionInfos.length - 1]
}

export const getLatestTag = async () => {
  const tags = await git.tags()
  return tags.latest
}
/**
 * @param {{version:string,buildNumber:number}} info
 */
export const formatVersionInfo = (info) => {
  return `v${info.version}+${info.buildNumber}`
}
