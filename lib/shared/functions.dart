import 'dart:async';
import 'package:sql_treino/services/local/RAM.dart';

Future<String> getUserEmail() async {
  RAM ram = await RAM().load();
  return (await ram.readData())['logged'];
}
