import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  final TextEditingController controller;
  final String label, hint;
  final bool hide;
  final TextInputType? keyboardType;
  final String? prefixText;
  final void Function(String)? onChanged;

  const Input({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    this.hide = false,
    this.keyboardType,
    this.prefixText,
    this.onChanged,
  }) : super(key: key);

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  InputDecoration get decoration => InputDecoration(
        hintText: widget.hint,
        labelText: widget.label,
        prefixText: widget.prefixText,
        labelStyle: TextStyle(
          fontSize: 15,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 25),
      child: TextFormField(
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        onChanged: widget.onChanged,
        obscureText: widget.hide,
        decoration: decoration,
        style: TextStyle(
          fontSize: 18,
        ),
        cursorWidth: 1.5,
        validator: (String? value) {
          if (value == null) return null;
          return value.isEmpty
              ? "O campo \"${widget.label}\" deve ser preenchido."
              : null;
        },
      ),
    );
  }
}
