import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sql_treino/routes.dart';

import 'package:sql_treino/shared/themes/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then(
    (value) => runApp(MaterialApp(
      color: AppTheme.primary,
      initialRoute: "/splash",
      routes: routes,
    )),
  );
}
