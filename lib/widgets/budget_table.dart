import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../models/budget_item.dart';
import '../state/budget_info.dart';

enum _SortOrder { none, asc, desc }

class BudgetTable extends StatefulWidget {
  final List<BudgetItem> items;
  final String itemTableLabel;
  final String amountTableLabel;
  final Color headerColor;

  const BudgetTable({
    super.key,
    required this.items,
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
    if (_sortOrder == _SortOrder.none) return widget.items;
    final sorted = [...widget.items];
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

  double get _total => widget.items.fold(0.0, (sum, e) => sum + e.amount);

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

    return Watch(
      (context) => ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: tableHeight,
          child: Column(
            spacing: 10,
            children: [
              Expanded(
                child: DataTable2(
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
                                  widget.items.removeAt(i);
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
                                    widget.items.clear();
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
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () => setState(() {
                      isVisible = !isVisible;
                    }),
                    child: Text("Edit"),
                  ),
                  TextButton(
                    onPressed: () => setState(() {
                      isVisible = !isVisible;
                    }),
                    child: Text("Save"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
