import re
import subprocess
import sys

# 从pubspec.yaml文件中读取版本号，格式为x.x.x+x
with open('pubspec.yaml', 'r') as file:
    filedata = file.read()
version = re.findall(r'version: (\d+.\d+.\d+)', filedata)[0]
oldBuildNumber = re.findall(r'version: \d+.\d+.\d+(\+\d+)', filedata)
if len(oldBuildNumber) == 0:
    buildNumber = 0
else:
    buildNumber = int(oldBuildNumber[0][1:])
    oldBuildNumber = buildNumber

# 版本号加1
buildNumber += 1
oldVersion = version + '+' + str(oldBuildNumber)
newVersion = version + '+' + str(buildNumber)
print('newVersion: ' + newVersion)
print('buildNumber: ' + str(oldBuildNumber) + ' -> ' + str(buildNumber))

# 将新的版本号写入pubspec.yaml文件
filedata = filedata.replace(f'version: ' + oldVersion, 'version: ' + newVersion)
with open('pubspec.yaml', 'w') as file:
    file.write(filedata)

# 接收参数，如果传值参数无输入，则跳过
if len(sys.argv) != 1:
    cmd = f'git add .'
    subprocess.run(cmd, shell=True)
    cmd = f'git commit -m "build: {newVersion}"'
    subprocess.run(cmd, shell=True)

    # {{ github.server_url }}
    server_url = sys.argv[1]
    # {{ github.repository }}
    repository = sys.argv[2]
    # {{ github.run_id }}
    run_id = sys.argv[3]
    # {{ github.run_attempt }} SHOULD BE 1
    run_attempt = sys.argv[4]
    cmd = f'git tag -a v{newVersion} -m "v{newVersion}\nrun id: {run_id}\nrun_attempt(should be 1): {run_attempt}\n{server_url}/{repository}/actions/runs/{run_id}"'
    subprocess.run(cmd, shell=True)
