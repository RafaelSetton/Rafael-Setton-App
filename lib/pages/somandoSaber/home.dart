import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget navigationButton(String text, String target) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed("/somando-saber-$target");
      },
      child: Text(text),
    );
  }

  Widget home() {
    return Container(
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage("lib/assets/Somando_Saber/background.jpg"),
          fit: BoxFit.cover,
          alignment: Alignment.centerRight,
        ),
        color: Colors.black,
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          navigationButton("Jogar", "select"),
          navigationButton("Pontuações", "scores"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Somando Saber"),
        centerTitle: true,
      ),
      body: home(),
    );
  }
}
