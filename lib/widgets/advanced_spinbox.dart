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

import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:signals/signals_flutter.dart';

class AdvancedSpinbox extends StatefulWidget {
  final String labelText;
  final String currency;
  final FlutterSignal<double> amountSignal;
  const AdvancedSpinbox({super.key, this.labelText = "", this.currency = "", required this.amountSignal});
  @override
  State<AdvancedSpinbox> createState() => _AdvancedSpinBoxState();
}
class _AdvancedSpinBoxState extends State<AdvancedSpinbox> {
  final FocusNode _focus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Watch((context) => SpinBox(
      max: 1000000000,
      min: 1,
      value: widget.amountSignal.value,
      decimals: 2,
      step: 100,
      focusNode: _focus,
      onChanged: (value) => widget.amountSignal.value = value,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: const OutlineInputBorder(),
        prefix: Text(widget.currency, style: TextStyle(fontSize: 20)),
      ),
    ));
  }

}