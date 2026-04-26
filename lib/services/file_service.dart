import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';

class FileService {
  static String? pathChosen;

  static Future<void> saveFileWindows(Uint8List bytes, String fileName) async {
    pathChosen = null;
    String? path = await FilePicker.getDirectoryPath(
      dialogTitle: "Save your JSON file in",
    );
    if (path != null) {
      await File("$path\\$fileName.json").writeAsBytes(bytes);
      pathChosen = path;
    }
  }

  static Future<void> saveFileWeb(Uint8List bytes, String fileName) async {
    pathChosen = null;
    String path = await FileSaver.instance.saveFile(
      name: fileName,
      bytes: bytes,
      mimeType: MimeType.json,
    );
    if (path.isNotEmpty) pathChosen = path;
  }
}
