import { extractVersionAndBuildNumberFromTag, getLargestTag } from "./git.mjs"

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

/**
 *
 * @param {string | {version:string,buildNumber:number}} newVersionFull
 */
export const guardVersioning = async (newVersionFull) => {
  const { version, buildNumber } = parseVersion(newVersionFull)
  const largestTag = await getLargestTag()
  console.log(`The largest tag from git is ${largestTag}`)
  const upgradeDelta = buildNumber - largestTag.buildNumber
  if (upgradeDelta <= 0) {
    throw new Error(`${newVersionFull} should be larger than ${largestTag}`)
  }
  if (upgradeDelta > 1) {
    throw new Error(`${newVersionFull} upgrades more than one build numbers than ${largestTag}`)
  }
}
