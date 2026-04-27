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

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../models/budget_item.dart';
import '../models/budget_type.dart';
import '../services/file_service.dart';
import '../state/budget_info.dart';
enum _SortOrder { none, asc, desc }

class BudgetTable extends StatefulWidget {
  final BudgetType type;
  final String itemTableLabel;
  final String amountTableLabel;
  final Color headerColor;

  const BudgetTable({
    super.key,
    required this.type,
    required this.itemTableLabel,
    required this.amountTableLabel,
    required this.headerColor,
  });

  @override
  State<BudgetTable> createState() => _BudgetTableState();
}

class _BudgetTableState extends State<BudgetTable> {
  int _sortColumnIndex = 0;
  _SortOrder _sortOrder = _SortOrder.none;
  int? _hoveredRow;
  bool isVisible = false;

  List<BudgetItem> get _sortedItems {
    if (_sortOrder == _SortOrder.none) return widget.type.items.value;
    final sorted = [...widget.type.items.value];
    sorted.sort((a, b) {
      final cmp = _sortColumnIndex == 0
          ? a.name.compareTo(b.name)
          : a.amount.compareTo(b.amount);
      return _sortOrder == _SortOrder.asc ? cmp : -cmp;
    });
    return sorted;
  }

  void _onSort(int columnIndex) {
    setState(() {
      if (_sortColumnIndex == columnIndex) {
        _sortOrder = switch (_sortOrder) {
          _SortOrder.none => _SortOrder.asc,
          _SortOrder.asc => _SortOrder.desc,
          _SortOrder.desc => _SortOrder.none,
        };
      } else {
        _sortColumnIndex = columnIndex;
        _sortOrder = _SortOrder.asc;
      }
    });
  }

  double get _total => widget.type.items.value.fold(0.0, (sum, e) => sum + e.amount);

  Color _rowColor(int index, Set<WidgetState> states) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (states.contains(WidgetState.selected)) {
      return widget.headerColor.withValues(alpha: 0.25);
    }
    if (_hoveredRow == index) {
      return widget.headerColor.withValues(alpha: 0.08);
    }
    if (index.isOdd) {
      return isDark
          ? Colors.white.withValues(alpha: 0.03)
          : Colors.black.withValues(alpha: 0.02);
    }
    return Colors.transparent;
  }

  Widget _sortIcon(int columnIndex) {
    if (_sortColumnIndex != columnIndex || _sortOrder == _SortOrder.none) {
      return Icon(Icons.unfold_more, size: 14, color: Colors.white54);
    }
    return Icon(
      _sortOrder == _SortOrder.asc ? Icons.arrow_upward : Icons.arrow_downward,
      size: 14,
      color: Colors.white,
    );
  }

  DataColumn _buildColumn(String label, int index) {
    return DataColumn(
      label: InkWell(
        onTap: () => _onSort(index),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            _sortIcon(index),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final sorted = _sortedItems;
    final currency = budgetInfo.currency.value;

    final tableHeight = ((sorted.length + 2) * 52.0) + 42.0;

    return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: tableHeight,
          child: Column(
            spacing: 10,
            children: [
              Expanded(
                  child: Watch(
                        (context) =>
                        DataTable2(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[900] : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  headingRowColor: WidgetStateProperty.all(widget.headerColor),
                  headingTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  headingRowHeight: 52,
                  dataRowHeight: 52,
                  dataRowColor: WidgetStateProperty.resolveWith(
                    (_) => Colors.transparent,
                  ),
                  dataTextStyle: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                    fontSize: 14,
                  ),
                  dividerThickness: 0,
                  border: TableBorder(
                    horizontalInside: BorderSide(
                      color: isDark ? Colors.white12 : Colors.black12,
                      width: 0.5,
                    ),
                  ),
                  columns: [
                    _buildColumn(widget.itemTableLabel, 0),
                    _buildColumn(widget.amountTableLabel, 1),
                    if (isVisible) _buildColumn("Actions", 0),
                  ],
                  rows: [
                    ...List.generate(sorted.length, (i) {
                      final item = sorted[i];
                      return DataRow(
                        color: WidgetStateProperty.resolveWith(
                          (states) => _rowColor(i, states),
                        ),
                        cells: [
                          DataCell(
                            MouseRegion(
                              onEnter: (_) => setState(() => _hoveredRow = i),
                              onExit: (_) => setState(() => _hoveredRow = null),
                              child: Text(item.name),
                            ),
                          ),
                          DataCell(
                            MouseRegion(
                              onEnter: (_) => setState(() => _hoveredRow = i),
                              onExit: (_) => setState(() => _hoveredRow = null),
                              child: Text(
                                '$currency ${item.amount.toStringAsFixed(2)}',
                                style: const TextStyle(fontFamily: 'monospace'),
                              ),
                            ),
                          ),
                          if (isVisible)
                            DataCell(
                              IconButton(
                                onPressed: () => setState(() {
                                  widget.type.items.value.removeAt(i);
                                }),
                                icon: Icon(Icons.close),
                                color: Colors.red,
                              ),
                            ),
                        ],
                      );
                    }),
                    // total row
                    DataRow(
                      color: WidgetStateProperty.all(
                        widget.headerColor.withOpacity(0.15),
                      ),
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: widget.headerColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Text(
                            '$currency ${_total.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                              color: widget.headerColor,
                            ),
                          ),
                        ),
                        if (isVisible)
                          DataCell(
                            IconButton(
                              onPressed: () => setState(() {
                                    widget.type.items.value.clear();
                              }),
                              icon: Column(
                                children: [
                                  Icon(Icons.close, size: 15),
                                  Text(
                                    "All",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                  )),
              Row(
                children: [
                  TextButton(
                    onPressed: () => setState(() {
                      isVisible = !isVisible;
                    }),
                    child: Text("Edit"),
                  ),
                  if (defaultTargetPlatform != TargetPlatform.android && defaultTargetPlatform != TargetPlatform.iOS)
                  TextButton(
                    onPressed: () async {
                      Uint8List bytes = Uint8List.fromList(utf8.encode(
                          jsonEncode(widget.type.items.value)));
                      if (kIsWeb) {
                        await FileService.saveFileWeb(bytes, widget.type
                            .representation.toLowerCase());
                      }
                      else
                      if (defaultTargetPlatform == TargetPlatform.windows) {
                        await FileService.saveFileWindows(bytes,
                            widget.type.representation.toLowerCase());
                      }
                      if (FileService.pathChosen != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content:
                          Row(
                            children: [
                              Text(
                              'Success: Saved ${widget.type.representation
                                  .toLowerCase()}.json to ${FileService
                                  .pathChosen}.',
                                  style: TextStyle(color: Colors.white)
                              ),
                              Spacer(),
                              Icon(
                                  Icons.check_circle_outline
                              ),
                            ],
                          ),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: Text("Save"),
                  ),
                  if (defaultTargetPlatform != TargetPlatform.android &&
                      defaultTargetPlatform != TargetPlatform.iOS)
                    TextButton(
                      onPressed: () async {
                        Uint8List bytes = Uint8List.fromList(utf8.encode(
                            jsonEncode(widget.type.items.value)));
                        if (kIsWeb) {
                          await FileService.saveFileWeb(bytes, widget.type
                              .representation.toLowerCase());
                        }
                        else
                        if (defaultTargetPlatform == TargetPlatform.windows) {
                          var content = await FileService.loadFileWindows();
                          switch (content.result) {
                            case FileLoadResult.success:
                              setState(() =>
                              widget.type.items.value = content.items!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content:
                                Row(
                                  children: [
                                    Text(
                                        'Successfully loaded the JSON file.',
                                        style: TextStyle(color: Colors.white)
                                    ),
                                    Spacer(),
                                    Icon(
                                        Icons.check_circle_outline
                                    ),
                                  ],
                                ),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            case FileLoadResult.cancelled:
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content:
                                Row(
                                  children: [
                                    Text(
                                        'Loading Cancelled',
                                        style: TextStyle(color: Colors.white)
                                    ),
                                    Spacer(),
                                    Icon(
                                        Icons.error_outline
                                    ),
                                  ],
                                ),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            case FileLoadResult.error:
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content:
                                Row(
                                  children: [
                                    Text(
                                        'Error: Failed to load the JSON file, it could be invalid.',
                                        style: TextStyle(color: Colors.white)
                                    ),
                                    Spacer(),
                                    Icon(
                                        Icons.highlight_off
                                    ),
                                  ],
                                ),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                          }
                        }
                        if (FileService.pathChosen != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content:
                            Row(
                              children: [
                                Text(
                                    'Success: Saved ${widget.type.representation
                                        .toLowerCase()}.json to ${FileService
                                        .pathChosen}.',
                                    style: TextStyle(color: Colors.white)
                                ),
                                Spacer(),
                                Icon(
                                    Icons.check_circle_outline
                                ),
                              ],
                            ),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: Text("Load"),
                    ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}
