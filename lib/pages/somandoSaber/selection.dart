import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sql_treino/shared/models/gameMode.dart';
import 'package:sql_treino/shared/globals.dart' as globals;

class SelectionPage extends StatefulWidget {
  const SelectionPage({Key? key}) : super(key: key);

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  @override
  void initState() {
    player.setSourceAsset("../lib/assets/Somando_Saber/button.wav");
    super.initState();
  }

  AudioPlayer player = AudioPlayer();

  Widget navigationButton(BuildContext context, String text) {
    globals.arguments = text;
    return ElevatedButton(
      onPressed: () async {
        Navigator.of(context).pushNamed("/somando-saber-game");
      },
      child: Text(text),
    );
  }

  Widget body(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage("lib/assets/Somando_Saber/background.jpg"),
          fit: BoxFit.cover,
          alignment: Alignment.centerLeft,
        ),
        color: Colors.black,
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          navigationButton(context, GameMode.add),
          navigationButton(context, GameMode.sub),
          navigationButton(context, GameMode.mult),
          navigationButton(context, GameMode.div),
          navigationButton(context, GameMode.addSub),
          navigationButton(context, GameMode.addMult),
          navigationButton(context, GameMode.addDiv),
          navigationButton(context, GameMode.subMult),
          navigationButton(context, GameMode.subDiv),
          navigationButton(context, GameMode.multDiv),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Selecione o modo de jogo"),
        centerTitle: true,
      ),
      body: body(context),
    );
  }
}
