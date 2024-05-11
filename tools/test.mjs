import { guardVersioning } from "./guard.mjs"
async function main() {
  await guardVersioning("v2.5.0+442")
}

main()
