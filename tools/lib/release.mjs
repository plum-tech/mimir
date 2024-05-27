import { github } from './github.mjs'
import crypto from "crypto"

/**
 * @param {({name:string,browser_download_url:string})=>boolean} filter
 */
export async function searchAndGetAssetInfo(filter) {
  const asset = searchAsset(filter)
  if (!asset) return
  return await getAssetInfo(asset)
}

/**
 * @template {{name:string,browser_download_url:string}} T
 * @param {(T)=>boolean} filter
 * @returns {T | undefined}
 */
function searchAsset(filter) {
  const assets = github.release.assets
  for (const asset of assets) {
    if (filter(asset)) {
      return asset
    }
  }
  return
}

/**
 *
 * @param {{name:string,browser_download_url:string}} payload
 */
async function getAssetInfo(payload) {
  const url = payload.browser_download_url
  let sha256 = ""
  if (url) {
    sha256 = await downloadAndSha256Hash(url)
  }
  return {
    name: payload.name,
    url: url,
    sha256: sha256,
  }
}


/**
 *
 * @param {string} url
 */
async function downloadAndSha256Hash(url) {
  const response = await fetch(url)
  const chunks = []
  for await (const chunk of response.body) {
    chunks.push(chunk)
  }
  const buffer = Buffer.concat(chunks)
  const hash = crypto.createHash('sha256').update(buffer).digest('hex')
  return hash
}
