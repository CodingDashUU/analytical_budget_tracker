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

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../state/budget_info.dart';

class DonutChart extends StatefulWidget {
  final List<MapEntry<String, double>> data;
  final List<Color>? colors;

  const DonutChart({super.key, required this.data, this.colors});

  @override
  State<DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart>
    with SingleTickerProviderStateMixin {
  int touchedIndex = -1;
  late final AnimationController _animController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  )..forward();
  late final Animation<double> _anim = CurvedAnimation(
    parent: _animController,
    curve: Curves.easeOutCubic,
  );


  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Color _colorAt(int i) {
    if (widget.colors != null) return widget.colors![i];
    final hue = (360 / widget.data.length) * i;
    return HSLColor.fromAHSL(1.0, hue, 0.6, 0.5).toColor();
  }

  double get _total =>
      widget.data.fold(0, (sum, e) => sum + e.value);

  Widget _buildBadge(int i) {
    final pct = _total > 0
        ? (widget.data[i].value / _total * 100).toStringAsFixed(1)
        : '0.0';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.square, size: 12, color: _colorAt(i)),
              const SizedBox(width: 4),
              Text(
                widget.data[i].key,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '${budgetInfo.currency.value} ${widget.data[i].value.toStringAsFixed(2)}  •  $pct%',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(widget.data.length, (i) {
          final isHighlighted = i == touchedIndex;
          return GestureDetector(
            onTap: () => setState(() {
              touchedIndex = touchedIndex == i ? -1 : i;
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: isHighlighted
                    ? _colorAt(i).withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _colorAt(i),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.data[i].key,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isHighlighted
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isHighlighted ? _colorAt(i) : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Row(
        children: [
          Expanded(
            child: AnimatedBuilder(
              animation: _anim,
              builder: (context, _) => PieChart(
                PieChartData(
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                  startDegreeOffset: -90,
                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) {
                      setState(() {
                        touchedIndex =
                        event.isInterestedForInteractions &&
                            response?.touchedSection != null
                            ? response!
                            .touchedSection!.touchedSectionIndex
                            : -1;
                        if (response?.touchedSection != null) {
                          HapticFeedback.selectionClick();
                        }
                      });
                    },
                    mouseCursorResolver: (event, response) =>
                    response?.touchedSection != null
                        ? SystemMouseCursors.click
                        : SystemMouseCursors.basic,
                  ),
                  sections: List.generate(widget.data.length, (i) {
                    final isTouched = i == touchedIndex;
                    final double radius = isTouched ? 70.0 : 55.0;

                    return PieChartSectionData(
                      color: _colorAt(i),
                      value: widget.data[i].value * _anim.value,
                      cornerRadius: 8,
                      showTitle: false,
                      radius: radius,
                      badgeWidget: isTouched ? _buildBadge(i) : null,
                      badgePositionPercentageOffset: 1.1,
                      borderSide: isTouched
                          ? const BorderSide(color: Colors.white, width: 2)
                          : const BorderSide(color: Colors.transparent),
                      gradient: LinearGradient(
                        colors: [
                          _colorAt(i).withOpacity(0.8),
                          _colorAt(i),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _buildLegend(),
        ],
      ),
    );
  }
}