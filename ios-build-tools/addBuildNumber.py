import re

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
