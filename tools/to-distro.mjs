import fs from 'fs/promises'; // For file system operations

const projectPbxprojPath = 'ios/Runner.xcodeproj/project.pbxproj';

async function main() {
  // Read project.pbxproj file content
  const filedata = await fs.readFile(projectPbxprojPath, 'utf-8');

  // Replace CODE_SIGN_IDENTITY
  filedata = filedata.replace(
    'CODE_SIGN_IDENTITY = "Apple Development";',
    'CODE_SIGN_IDENTITY = "Apple Distribution";',
  );

  // Replace CODE_SIGN_STYLE
  filedata = filedata.replace('CODE_SIGN_STYLE = Automatic;', 'CODE_SIGN_STYLE = Manual;');

  // Replace DEVELOPMENT_TEAM
  filedata = filedata.replace('DEVELOPMENT_TEAM = "";', 'DEVELOPMENT_TEAM = "M5APZD5CKA";');

  // Replace PROVISIONING_PROFILE_SPECIFIER
  filedata = filedata.replace(
    'PROVISIONING_PROFILE_SPECIFIER = "";',
    'PROVISIONING_PROFILE_SPECIFIER = "SITLife-Distribution-AppStore";',
  );

  // Write updated file content back to the file
  await fs.writeFile(projectPbxprojPath, filedata);
}

main()
