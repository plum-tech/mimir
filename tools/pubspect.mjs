export function getVersion(pubspec) {
  const versionMatch = pubspec.match(/version: (\d+.\d+.\d+)/)
  if (!versionMatch) {
    throw new Error('Could not find version in pubspec.yaml')
  }
  return versionMatch[1]
}

export function getBuildNumber(pubspec) {
  const buildNumberMatch = pubspec.match(/version: \d+.\d+.\d+(\+\d+)/)
  return buildNumberMatch ? parseInt(buildNumberMatch[1].slice(1)) : 0
}
