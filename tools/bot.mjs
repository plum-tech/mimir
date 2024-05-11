/**
 *
 * @param {{botUrl: string, groupNumber:string,message:string}} param0
 * @returns
 */
export async function sendMessageToQQGroup({ botUrl, groupNumber, message }) {
  const res = await fetch(botUrl, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: new URLSearchParams({
      group_id: groupNumber,
      message,
    }),
  })

  const result = await res.text()
  return result
}
