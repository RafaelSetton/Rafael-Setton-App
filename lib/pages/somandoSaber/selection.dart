import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sql_treino/shared/globals.dart' as globals;
import 'package:typicons_flutter/typicons_flutter.dart';

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

  Map<String, bool> selected = Map();
  AudioPlayer player = AudioPlayer();

  Widget selectionWidget(String text, IconData icon) {
    if (!selected.containsKey(text)) selected[text] = false;
    return InputChip(
      label: Text(text),
      avatar: Icon(icon),
      onSelected: (value) => setState(() {
        selected[text] = !selected[text]!;
      }),
      selected: selected[text]!,
    );
  }

  Widget navigationButton() {
    return Container(
      height: 50,
      width: 150,
      child: ElevatedButton(
        onPressed: () {
          player.resume();
          globals.arguments =
              selected.keys.where((k) => selected[k]!).join(" ");
          Navigator.pushNamed(context, "/somando-saber-game");
        },
        child: Text(
          "Iniciar",
          style: TextStyle(fontSize: 20),
        ),
      ),
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
          SizedBox(
            height: 450,
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                selectionWidget("Adição", Icons.add),
                selectionWidget("Subtração", Icons.remove),
                selectionWidget("Multiplicação", Icons.close),
                selectionWidget("Divisão", Typicons.divide),
              ],
            ),
          ),
          navigationButton(),
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
