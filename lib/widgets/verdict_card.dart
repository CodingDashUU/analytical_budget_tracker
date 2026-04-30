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

import 'package:budget_tracker/state/analysis_model.dart';
import 'package:flutter/material.dart';

import '../state/budget_info.dart';

class VerdictCard extends StatelessWidget {
  final bool isLarge;
  const VerdictCard({super.key,
    required this.isLarge
});
  List<Text> _verdictContent(bool isLarge) {
    final s = isLarge
        ? (label: 24.0, value: 42.0, verdict: 48.0, verdictText: 40.0)
        : (label: 15.0, value: 24.0, verdict: 28.0, verdictText: 20.0);

    return [
        Text("Total Income", style: TextStyle(fontSize: s.label, color: Colors.white, fontWeight: FontWeight.w400)),
      Text("${budgetInfo.currency.value.isNotEmpty ? "${budgetInfo.currency
          .value} " : ""}${analysisModel.totalIncome.toStringAsFixed(2)}",
          style: TextStyle(fontSize: s.value,
              fontWeight: FontWeight.w600,
              color: Colors.green)),
        Text("Total Expenses", style: TextStyle(fontSize: s.label, color: Colors.white, fontWeight: FontWeight.w400)),
      Text("${budgetInfo.currency.value.isNotEmpty ? "${budgetInfo.currency
          .value} " : ""}${analysisModel.totalExpenses.toStringAsFixed(2)}",
          style: TextStyle(fontSize: s.value,
              fontWeight: FontWeight.w600,
              color: Colors.red)),
        Text("${budgetInfo.currency.value.isNotEmpty ? "${budgetInfo.currency.value} " : ""}${analysisModel.verdict.toStringAsFixed(2)}", style: TextStyle(fontSize: s.verdict, fontWeight: FontWeight.w600, color: analysisModel.verdictColor)),
        Text(analysisModel.verdictText, style: TextStyle(fontSize: s.verdictText, fontWeight: FontWeight.w800, color: analysisModel.verdictColor)),
      ];
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(height: 8),
                Text(
                  "Verdict",
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                Spacer(),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(child: Icon(Icons.circle, color: analysisModel.verdictColor),),
                ),
              ],
            ),
            ..._verdictContent(isLarge)

          ],
        ),
      ),
    );
  }
}