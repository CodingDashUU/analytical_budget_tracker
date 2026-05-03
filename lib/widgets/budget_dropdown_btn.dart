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

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/budget_type.dart';
import '../services/file_service.dart';

class BudgetDropdownButton extends StatefulWidget {
  final Function pageSetState;
  final BudgetType type;
  final IconData icon;

  const BudgetDropdownButton({
    required this.pageSetState,
    required this.type,
    required this.icon,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _BudgetDropdownButtonState();
}

class _BudgetDropdownButtonState extends State<BudgetDropdownButton> {
  bool fileDialogOpen = false;

  void onSave() async {
    setState(() {
      fileDialogOpen = true;
    });
    Uint8List bytes = Uint8List.fromList(
      utf8.encode(jsonEncode(widget.type.items.value)),
    );
    if (kIsWeb) {
      await FileService.saveFileWeb(
        bytes,
        widget.type.representation.toLowerCase(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.windows) {
      await FileService.saveFileWindows(
        bytes,
        widget.type.representation.toLowerCase(),
      );
    }
    if (FileService.pathChosen != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Text(
                'Success: Saved ${widget.type.representation
                    .toLowerCase()}.json to ${FileService.pathChosen}.',
                style: TextStyle(color: Colors.white),
              ),
              Spacer(),
              Icon(Icons.check_circle_outline),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
    setState(() {
      fileDialogOpen = false;
    });
  }

  void onLoad() async {
    setState(() {
      fileDialogOpen = true;
    });
    FileLoad? content;
    if (kIsWeb) {
      content = await FileService.loadFileWeb();
    } else if (defaultTargetPlatform == TargetPlatform.windows) {
      content = await FileService.loadFileWindows();
    }
    if (content != null) {
      switch (content.result) {
        case FileLoadResult.success:
          widget.pageSetState(() => widget.type.items.value = content!.items!);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Text(
                    'Successfully loaded the JSON file.',
                    style: TextStyle(color: Colors.white),
                  ),
                  Spacer(),
                  Icon(Icons.check_circle_outline),
                ],
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        case FileLoadResult.cancelled:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Text(
                    'Loading Cancelled',
                    style: TextStyle(color: Colors.white),
                  ),
                  Spacer(),
                  Icon(Icons.error_outline),
                ],
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        case FileLoadResult.error:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Text(
                    'Error: Failed to load the JSON file, it could be invalid.',
                    style: TextStyle(color: Colors.white),
                  ),
                  Spacer(),
                  Icon(Icons.highlight_off),
                ],
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
      }
    }
    setState(() {
      fileDialogOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "${widget.type.representation} options",
      child: DropdownButton2<Widget>(
        customButton: Icon(widget.icon, color: widget.type.representationColor),
        onChanged: (value) {},
        underline: const SizedBox.shrink(),
        dropdownStyleData: DropdownStyleData(
          width: 170,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black87,
          ),
        ),
        isExpanded: true,
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 40,
          width: 130,
        ),
        items:
        [
          if (defaultTargetPlatform != TargetPlatform.android &&
              defaultTargetPlatform != TargetPlatform.iOS)
            TextButton(
              onPressed: fileDialogOpen ? null : onSave,
              child: Text("Save ${widget.type.representation}"),
            ),
          if (defaultTargetPlatform != TargetPlatform.android &&
              defaultTargetPlatform != TargetPlatform.iOS)
            TextButton(
              onPressed: fileDialogOpen ? null : onLoad,
              child: Text("Load ${widget.type.representation}"),
            ),
        ].map((Widget item) => DropdownItem<Widget>(value: item, child: item)).toList(),
      ),
    );
  }
}
