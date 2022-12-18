import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'logger.dart';
import 'permission.dart';

class FileUtils {
  static Future<void> writeToFile({
    required dynamic content,
    required String filepath,
  }) async {
    final isPermissionGranted = await ensurePermission(Permission.storage);
    if (!isPermissionGranted) {
      throw '无写入文件权限';
    }

    final file = File(filepath);

    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    if (content is String) {
      await file.writeAsString(content);
    } else {
      await file.writeAsBytes(content);
    }
  }

  static Future<void> writeToTempFileAndOpen({
    required dynamic content,
    required String filename,
    required String type,
  }) async {
    final path = '${(await getTemporaryDirectory()).path}/$filename';
    await writeToFile(content: content, filepath: path);
    Log.info('保存文件$filename到 $path');
    OpenFile.open(path, type: type);
  }

  static Future<String?> pickImageByFilePicker() async {
    final pfs = await pickFiles(
      dialogTitle: '选择图片',
      type: FileType.image,
    );

    return pfs != null && pfs.isNotEmpty ? pfs[0] : null;
  }

  static Future<List<String>> pickImagesByFilePicker() async {
    return await pickFiles(
          dialogTitle: '选择图片',
          type: FileType.image,
          allowMultiple: true,
        ) ??
        [];
  }

  static Future<List<String>> pickImagesByImagePicker() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();
    return images?.map((e) => e.path).toList() ?? [];
  }

  static Future<XFile?> pickImageByImagePicker() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  static Future<List<String>?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    bool allowMultiple = false,
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: dialogTitle,
      initialDirectory: initialDirectory,
      type: type,
      allowedExtensions: allowedExtensions,
      allowMultiple: allowMultiple,
    );

    if (result == null) return null;
    return result.files //
        .map((e) => e.path) // 获取路径
        .where((e) => e != null) // 过滤掉所有的null
        .map((e) => e!) // 强制String?转String
        .toList(); // 输出列表
  }
}
