import { simpleGit } from 'simple-git'

const git = simpleGit()

/**
 * Extract the version and build number from a full version string like "v1.0.0+1" or "2.0.0+18"
 * @param {string} tag
 * @returns {[string, int]}
 */
export function extractVersionAndBuildNumberFromTag(tag) {
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
export async function getLargestTag() {
  const tags = await git.tags()
  // in ascending order
  const versionInfos = tags.all.map(tag => extractVersionAndBuildNumberFromTag(tag)).sort((a, b) => a[1] - b[1])
  return versionInfos[versionInfos.length - 1]
}
