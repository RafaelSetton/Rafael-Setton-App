import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:sql_treino/pages/home/games.dart';
import 'package:sql_treino/pages/home/profile.dart';
import 'package:sql_treino/pages/home/utilities.dart';
import 'package:sql_treino/services/localDB.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _currentPage = UtilitiesScreen();

  void logout() async {
    await RAM.write("user", null);
    Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Página do Usuário"),
          centerTitle: true,
          actions: [
            Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(25),
              ),
              margin: EdgeInsets.all(5),
              alignment: Alignment.center,
              child: IconButton(
                onPressed: logout,
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: _currentPage,
        bottomNavigationBar: CurvedNavigationBar(
          color: Theme.of(context).primaryColor,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          buttonBackgroundColor: Colors.grey.shade400,
          onTap: (index) {
            setState(() {
              _currentPage =
                  [UtilitiesScreen(), GamesScreen(), ProfileScreen()][index];
            });
          },
          items: [
            Icon(Icons.widgets, size: 30),
            Icon(Icons.videogame_asset_outlined, size: 30),
            Icon(Icons.person, size: 30),
          ],
        ),
      ),
    );
  }
}
