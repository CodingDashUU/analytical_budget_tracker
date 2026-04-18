import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signals/signals_flutter.dart';

class AdvancedTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String helperText;
  final IconData? prefixIcon;
  final int maxLength;
  final FlutterSignal<String> value;
  final String regexPattern;
  const AdvancedTextField(
     {
    super.key,
       required this.controller,
       required this.value,
       this.labelText = "",
       this.hintText = "",
       this.helperText = "",
       this.prefixIcon,
       this.maxLength = 20,
       this.regexPattern = r"",
  });
  @override
  State<AdvancedTextField> createState() => _AdvancedTextFieldState();
}

class _AdvancedTextFieldState extends State<AdvancedTextField> {
  final _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Watch((context) => TextField(
      onChanged: (value) => setState(() => widget.value.value = value),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(widget.regexPattern)),
      ],
      maxLength: widget.maxLength,
      controller: widget.controller,
      focusNode: _focusNode,
      autocorrect: false,
      enableSuggestions: false,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: widget.labelText,
        counter: Text(
          "${widget.controller.text.length} / ${widget.maxLength}",
          style: TextStyle(
            color: widget.controller.text.length != widget.maxLength ? null : Colors.red,
          ),
        ),
        hintText: widget.hintText,
        helperText: widget.helperText,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(widget.prefixIcon),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => setState(() { widget.controller.clear(); widget.value.value = "";} ),
        ),
      )),
    );
  }
}
