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