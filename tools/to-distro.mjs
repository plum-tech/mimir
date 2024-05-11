import fs from 'fs/promises' // For file system operations

const projectPbxprojPath = 'ios/Runner.xcodeproj/project.pbxproj'

const mapping = {
  'CODE_SIGN_IDENTITY = "Apple Development";': 'CODE_SIGN_IDENTITY = "Apple Distribution";',
  'CODE_SIGN_STYLE = Automatic;': 'CODE_SIGN_STYLE = Manual;',
  'DEVELOPMENT_TEAM = "";': 'DEVELOPMENT_TEAM = "M5APZD5CKA";',
  'PROVISIONING_PROFILE_SPECIFIER = "";': 'PROVISIONING_PROFILE_SPECIFIER = "SITLife-Distribution-AppStore";',
}

async function main() {
  // Read project.pbxproj file content
  let filedata = await fs.readFile(projectPbxprojPath, 'utf-8')

  for (const [origin, replacement] of Object.entries(mapping)) {
    filedata = filedata.replaceAll(origin, replacement)
  }

  // Write updated file content back to the file
  await fs.writeFile(projectPbxprojPath, filedata)
}

main()
