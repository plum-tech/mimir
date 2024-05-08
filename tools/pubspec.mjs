/**
 * Extract the version from pubspec.yaml
 * @param {string} pubspec
 * @returns {string}
 */
export function extractVersion(pubspec) {
  const versionMatch = pubspec.match(/version: (\d+.\d+.\d+)/)
  if (!versionMatch) {
    throw new Error('Could not find version in pubspec.yaml')
  }
  return versionMatch[1]
}
/**
 * Extract the build number from pubspec.yaml
 * @param {string} pubspec
 * @returns {int}
 */
export function extractBuildNumber(pubspec) {
  const buildNumberMatch = pubspec.match(/version: \d+.\d+.\d+(\+\d+)/)
  return buildNumberMatch ? parseInt(buildNumberMatch[1].slice(1)) : 0
}
