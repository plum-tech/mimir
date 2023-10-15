import re

# 实际显示版本号
version = '1.0.0'
# 实际构建版本号。默认情况时，每次构建时，都会自动+1。如果需要手动指定构建版本号，请将0修改为所需修改的值。
# 务必注意，App Store上架时，构建版本号必须大于上一次上架的构建版本号。
buildNumber = 0

# 读取project.pbxproj文件，查看CURRENT_PROJECT_VERSION的值，然后+1，再写回去
with open('ios/Runner.xcodeproj/project.pbxproj', 'r') as file:
    filedata = file.read()

if buildNumber == 0:
    # 获取当前构建号
    currentBuildNumber = re.findall(r'CURRENT_PROJECT_VERSION = (\d+);', filedata)[0]
    print('oldBuildNumber: ' + currentBuildNumber)
    currentBuildNumber = int(currentBuildNumber)
    currentBuildNumber += 1
else:
    print('(user defined)BuildNumber: ' + str(buildNumber))
    currentBuildNumber = buildNumber

# 替换版本号与构建版本号
filedata = re.sub(r'MARKETING_VERSION = (\d+.\d+.\d+);', 'MARKETING_VERSION = ' + version + ';', filedata)
filedata = re.sub(r'CURRENT_PROJECT_VERSION = (\d+);', 'CURRENT_PROJECT_VERSION = ' + str(currentBuildNumber) + ';', filedata)

print('currentBuildNumber: ' + str(version))
print('currentBuildNumber: ' + str(currentBuildNumber))
# 文件替换完成后，写回到文件中
with open('ios/Runner.xcodeproj/project.pbxproj', 'w') as file:
    file.write(filedata)
