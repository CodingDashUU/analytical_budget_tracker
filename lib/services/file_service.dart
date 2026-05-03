// Copyright (C) 2026 CodingDashUU
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:signals/signals_flutter.dart';

import '../models/budget_item.dart';

extension ToMap<T> on Iterable<T> {
  Map<K, V> toMap<K, V>(K Function(T) key, V Function(T) value) =>
      {for (var element in this) key(element): value(element)};
}
class FileService {
  static String? pathChosen;
  static FlutterSignal<bool> fileDialogOpen = signal(false);

  static Future<void> saveFileWindows(Uint8List bytes, String fileName) async {
    pathChosen = null;
    fileDialogOpen.value = true;
    String? path = await FilePicker.getDirectoryPath(
      dialogTitle: "Save your JSON file in",
    );
    if (path != null) {
      await File("$path\\$fileName.json").writeAsBytes(bytes);
      pathChosen = path;
    }
    fileDialogOpen.value = false;
  }

  static Future<FileLoad> loadFileWindows() async {
    pathChosen = null;
    fileDialogOpen.value = true;
    FilePickerResult? result = await FilePicker.pickFiles(
      dialogTitle: "Select a valid JSON file to load",
      allowMultiple: false,
      allowedExtensions: ["json"],
      type: FileType.custom,
    );
    fileDialogOpen.value = false;
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final String content = await file.readAsString();
      try {
        if (jsonDecode(content) is! List) {
          return FileLoad(
              FileLoadResult.success,
              [BudgetItem.fromJson(jsonDecode(content), 0)]
          );
        }
        return FileLoad(
          FileLoadResult.success,
          (jsonDecode(content) as List<dynamic>)
              .mapIndexed((i, e) => BudgetItem.fromJson(e, i + 1))
              .toMap((p0) => p0.name, (p0) => p0,)
              .values
              .toList(),
        );
      } catch (e) {
        return FileLoad(FileLoadResult.error, null);
      }
    }
    return FileLoad(FileLoadResult.cancelled, null);
  }

  static Future<FileLoad> loadFileWeb() async {
    pathChosen = null;
    fileDialogOpen.value = true;
    FilePickerResult? result = await FilePicker.pickFiles(
        dialogTitle: "Select a valid JSON file to load",
        allowMultiple: false,
        allowedExtensions: ["json"],
        type: FileType.custom,
        withData: true
    );
    fileDialogOpen.value = false;
    if (result != null && result.files.single.bytes != null) {
      final content = utf8.decode(result.files.single.bytes!.toList());
      try {
        if (jsonDecode(content) is! List) {
          return FileLoad(
              FileLoadResult.success,
              [BudgetItem.fromJson(jsonDecode(content), 0)]
          );
        }
        return FileLoad(
          FileLoadResult.success,
          (jsonDecode(content) as List<dynamic>)
              .mapIndexed((i, e) => BudgetItem.fromJson(e, i + 1))
              .toList(),
        );
      } catch (e) {
        return FileLoad(FileLoadResult.error, null);
      }
    }
    return FileLoad(FileLoadResult.cancelled, null);
  }

  static Future<void> saveFileWeb(Uint8List bytes, String fileName) async {
    pathChosen = null;
    fileDialogOpen.value = false;
    String path = await FileSaver.instance.saveFile(
      name: fileName,
      bytes: bytes,
      mimeType: MimeType.json,
    );
    if (path.isNotEmpty) pathChosen = path;
    fileDialogOpen.value = false;
  }
}

enum FileLoadResult { success, cancelled, error }

class FileLoad {
  FileLoadResult result;
  List<BudgetItem>? items;

  FileLoad(this.result, this.items);
}
