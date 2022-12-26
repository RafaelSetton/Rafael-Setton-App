import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sql_treino/routes.dart';
import 'package:sql_treino/services/themenotifier.dart';
import 'package:sql_treino/shared/themes.dart' as Themes;

Future setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.white));
}

void main() {
  setup().then(
    (value) => runApp(
      ChangeNotifierProvider<ThemeChanger>(
        create: (_) => ThemeChanger(Themes.light),
        child: MaterialAppWithTheme(),
      ),
    ),
  );
}

class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      theme: theme.getTheme(),
      initialRoute: "/splash",
      routes: routes,
    );
  }
}
