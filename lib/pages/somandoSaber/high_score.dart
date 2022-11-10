import 'package:flutter/material.dart';
import 'package:sql_treino/shared/models/SSAScoreModel.dart';
import 'package:intl/intl.dart';
import 'package:sql_treino/services/storage.dart';

class HighScorePage extends StatefulWidget {
  const HighScorePage({Key? key}) : super(key: key);

  @override
  State<HighScorePage> createState() => _HighScorePageState();
}

class _HighScorePageState extends State<HighScorePage> {
  List<SSAScoreModel> highScores = [];

  @override
  void initState() {
    SSAScoresDB.get().then((value) => setState(() {
          highScores = value;
        }));
    super.initState();
  }

  Container numberBox(int text, Color color) {
    return Container(
      height: 50,
      width: 70,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.center,
      child: Text(
        text.toString(),
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget scoreTile(BuildContext context, int index) {
    SSAScoreModel score = highScores[index];

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide()),
      ),
      child: ListTile(
        dense: true,
        leading: SizedBox(
          width: 150,
          child: Row(
            children: [
              numberBox(score.right, Colors.green),
              const SizedBox(width: 10),
              numberBox(score.wrong, Colors.red),
            ],
          ),
        ),
        title: Text(
          DateFormat('dd/MM/yyyy').format(score.dateTime),
        ),
        subtitle: Text(
          DateFormat('kk:mm:ss').format(score.dateTime),
        ),
        trailing: Container(
          height: 50,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.center,
          child: Text(score.mode, textAlign: TextAlign.center),
        ),
        style: ListTileStyle.drawer,
      ),
    );
  }

  Widget header(String text, double width) {
    return Container(
      width: width,
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      decoration: const BoxDecoration(
        border: Border.symmetric(
          vertical: BorderSide(),
        ),
      ),
    );
  }

  Widget body() {
    return Column(
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
          ),
          child: Row(
            children: [
              const SizedBox(width: 15),
              header("Acertos ⬇", 75),
              header("Erros ⬇", 75),
              header("Data e Hora ⬇", 100),
              header("Modo ⬇", 125),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              128,
          child: ListView.builder(
            itemBuilder: scoreTile,
            itemCount: highScores.length,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pontuações"),
        centerTitle: true,
      ),
      body: body(),
    );
  }
}
