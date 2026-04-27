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
