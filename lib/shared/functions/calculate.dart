import 'dart:math';
import 'package:function_tree/function_tree.dart';

String calculate(String string) {
  string = string
      .replaceAll('π', pi.toString())
      .replaceAll('e', e.toString())
      .replaceAll('÷', '/')
      .replaceAll('X', '*')
      .replaceAll(',', '.');
  try {
    return string.interpret().toString().replaceAll('.', ',');
  } catch (e) {
    return "Syntax";
  }
}
