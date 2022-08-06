import 'package:flutter/material.dart';

Widget input(
    {required TextEditingController controller,
    required String label,
    required String hint,
    bool hide = false,
    TextInputType? keyboardType,
    String? prefixText,
    void Function(String)? onChanged}) {
  InputDecoration decoration = InputDecoration(
    hintText: hint,
    labelText: label,
    prefixText: prefixText,
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

  return Container(
    padding: EdgeInsets.all(8),
    margin: EdgeInsets.only(bottom: 25),
    child: TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      onChanged: onChanged,
      obscureText: hide,
      decoration: decoration,
      style: TextStyle(
        fontSize: 18,
      ),
      cursorWidth: 1.5,
      validator: (String? value) {
        if (value == null) return null;
        return value.isEmpty ? "O campo \"$label\" deve ser preenchido." : null;
      },
    ),
  );
}
