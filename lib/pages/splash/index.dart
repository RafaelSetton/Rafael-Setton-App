import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sql_treino/services/localDB.dart';
import 'package:sql_treino/services/themenotifier.dart';
import 'package:sql_treino/shared/themes.dart' as Themes;
import 'package:sql_treino/shared/globals.dart' as globals;

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future authorize(BuildContext context) async {
    await globals.loadVars();

    /*final col = await UserDB.collection.get();
    for (var doc in col.docs) {
      String id = doc.id;
      var document = await UserDB.collection.doc(id).get();
      Map<String, dynamic> user = document.data()! as Map<String, dynamic>;

      // Modify
      
      // End modifications

      await UserDB.collection.doc(id).set(user);
    }*/

    String route = globals.userEmail.isNotEmpty ? "/userpage" : "/login";

    Navigator.pushReplacementNamed(context, route);

    RAM.read("darkTheme").then((value) {
      Provider.of<ThemeChanger>(context, listen: false)
          .setTheme(value == "true" ? Themes.dark : Themes.light);
    });
  }

  @override
  void initState() {
    super.initState();
    authorize(context);
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width / 1.3;
    return Container(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage("lib/assets/splashImage.png"),
            fit: BoxFit.fill,
          ),
        ),
        width: size,
        height: size,
      ),
      alignment: Alignment.center,
    );
  }
}
