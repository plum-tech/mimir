import { simpleGit } from "simple-git"
async function main() {
  const git = simpleGit()
  const tags = await git.tags()
  console.log(tags)
}

main()
