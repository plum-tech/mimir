import { extractVersionAndBuildNumberFromTag, formatVersionInfo, getLargestTag } from "./git.js"

/**
 *
 * @param {string | {version:string,buildNumber:number}} fullVersion
 */
export const parseVersion = (fullVersion) => {
  if (typeof fullVersion === "string") {
    return extractVersionAndBuildNumberFromTag(fullVersion)
  } else if (typeof fullVersion === "object") {
    return fullVersion
  } else {
    throw new Error(`${fullVersion} is not a version`)
  }
}

const maxUpgradedDelta = 2

/**
 *
 * @param {string | {version:string,buildNumber:number}} newVersionFull
 */
export const guardVersioning = async (newVersionFull) => {
  const { version, buildNumber } = parseVersion(newVersionFull)
  const largestInfo = await getLargestTag(version)
  if (!largestInfo) {
    console.log(`No existing tags for v${version}`)
    return
  }
  console.log(`The largest tag from git is ${formatVersionInfo(largestInfo)}`)
  const upgradeDelta = buildNumber - largestInfo.buildNumber
  if (upgradeDelta <= 0) {
    throw new Error(`${newVersionFull} should be larger than ${formatVersionInfo(largestInfo)}`)
  }
  if (upgradeDelta > maxUpgradedDelta) {
    throw new Error(`${newVersionFull} upgrades more than ${maxUpgradedDelta} build numbers at once than ${formatVersionInfo(largestInfo)}`)
  }
}

guardVersioning("v2.5.0+450")
