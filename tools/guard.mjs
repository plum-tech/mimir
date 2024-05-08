import { extractVersionAndBuildNumberFromTag, getLargestTag } from "./git.mjs"

/**
 *
 * @param {string | [string,int]} newVersionFull
 */
export async function guardVersioning(newVersionFull) {
  let newVersion, newBuildNumber
  if (typeof newVersionFull === "string") {
    [newVersion, newBuildNumber] = extractVersionAndBuildNumberFromTag(newVersionFull)
  } else if (Array.isArray(newVersionFull)) {
    [newVersion, newBuildNumber] = newVersionFull
  } else {
    throw new Error(`${newVersionFull} not recognized`)
  }
  const largestTag = await getLargestTag()
  console.log(`The largest tag from git is ${largestTag}`)
  const upgradeDelta = newBuildNumber - largestTag[1]
  if (upgradeDelta <= 0) {
    throw new Error(`${newVersionFull} is larger than ${largestTag}`)
  }
  if (upgradeDelta > 1) {
    throw new Error(`${newVersionFull} upgrades more than one build numbers than ${largestTag}`)
  }
}
