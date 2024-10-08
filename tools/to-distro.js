import esMain from 'es-main'
import fs from 'fs/promises' // For file system operations

const projectPbxprojPath = 'ios/Runner.xcodeproj/project.pbxproj'

const mapping = {
  'CODE_SIGN_IDENTITY = "Apple Development: JiaHao Li (BCG3D8Z5WX)";':
   'CODE_SIGN_IDENTITY = "Apple Distribution: Shanghai Plum Technology Ltd. (TGBYYVM7AB)";',
  'PROVISIONING_PROFILE_SPECIFIER = "mimir-dev team iOS Development mysit.life";':
   'PROVISIONING_PROFILE_SPECIFIER = "Plum Tech App Store Distro mysit.life";',
}

const main = async () => {
  // Read project.pbxproj file content
  let filedata = await fs.readFile(projectPbxprojPath, 'utf-8')

  for (const [origin, replacement] of Object.entries(mapping)) {
    filedata = filedata.replaceAll(origin, replacement)
  }

  // Write updated file content back to the file
  await fs.writeFile(projectPbxprojPath, filedata)
}

if (esMain(import.meta)) {
  main()
}
