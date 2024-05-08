import { guardVersioning } from "./guard.mjs"
async function main() {
  await guardVersioning("v2.4.1+445")
}

main()
