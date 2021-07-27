import 'package:flutter/material.dart';
import 'package:sql_treino/services/local/RAM.dart';
import 'package:sql_treino/shared/functions/loadVars.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future authorize(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 100));
    await loadVars();

    /*final col = await UserDB.collection.get();
    for (var doc in col.docs) {
      String id = doc.id;
      var document = await UserDB.collection.doc(id).get();
      Map<String, dynamic> user = document.data()! as Map<String, dynamic>;

      // Modify
      
      // End modifications

      UserDB.collection.doc(id).set(user);
    }*/

    String? email = await RAM.read("user");
    if (email != null)
      Navigator.pushReplacementNamed(context, "/userpage", arguments: email);
    else
      Navigator.pushReplacementNamed(context, "/login");
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
