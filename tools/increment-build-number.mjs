import fs from 'fs/promises'; // For file system operations
import { execSync } from 'child_process'; // For shell commands

const pubspecPath = 'pubspec.yaml';

async function main() {
  // Read pubspec.yaml content
  const filedata = await fs.readFile(pubspecPath, 'utf-8');

  // Extract version and build number
  const versionMatch = filedata.match(/version: (\d+.\d+.\d+)/);
  if (!versionMatch) {
    throw new Error('Could not find version in pubspec.yaml');
  }
  const version = versionMatch[1];

  const buildNumberMatch = filedata.match(/version: \d+.\d+.\d+(\+\d+)/);
  const buildNumber = buildNumberMatch ? parseInt(buildNumberMatch[1].slice(1)) + 1 : 1;

  // Generate new version and print information
  const oldVersion = version + '+' + (buildNumber - 1);
  const newVersion = version + '+' + buildNumber;
  console.log('newVersion: ' + newVersion);
  console.log('buildNumber: ' + (buildNumber - 1) + ' -> ' + buildNumber);

  // Update version in pubspec.yaml
  const updatedFiledata = filedata.replace(
    `version: ${oldVersion}`,
    `version: ${newVersion}`,
  );
  await fs.writeFile(pubspecPath, updatedFiledata);

  // Check for additional arguments
  if (process.argv.length > 1) {
    // Git operations (assuming arguments are provided)
    const serverUrl = process.argv[1];
    const repository = process.argv[2];
    const runId = process.argv[3];
    const runAttempt = process.argv[4];

    const addCommand = `git add .`;
    execSync(addCommand, { shell: true });

    const commitCommand = `git commit -m "build: ${newVersion}"`;
    execSync(commitCommand, { shell: true });

    const tagCommand = `git tag -a v${newVersion} -m "v${newVersion}\nrun id: ${runId}\nrun_attempt(should be 1): ${runAttempt}\n${serverUrl}/${repository}/actions/runs/${runId}"`;
    execSync(tagCommand, { shell: true });
  }
}

main().catch(error => {
  console.error(error);
  process.exit(1);
});
