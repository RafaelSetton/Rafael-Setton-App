import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sql_treino/services/local/RAM.dart';
import 'package:sql_treino/shared/models/workoutModel.dart';

class SelectionDialog extends StatefulWidget {
  const SelectionDialog({Key? key}) : super(key: key);

  @override
  _SelectionDialogState createState() => _SelectionDialogState();
}

class _SelectionDialogState extends State<SelectionDialog> {
  TextEditingController exerciseIntervalController =
      TextEditingController(text: "10");
  TextEditingController seriesIntervalController =
      TextEditingController(text: "20");
  TextEditingController seriesCountController =
      TextEditingController(text: "1");

  void onChanged(TextEditingController controller) {
    if (controller.text.isEmpty)
      controller.text = "0";
    else if (controller.text.length > 1 && controller.text.startsWith("0"))
      controller.text = controller.text.substring(1);
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
  }

  void saveAndPop() async {
    List<WorkoutModel> workouts = List<Map<String, dynamic>>.from(
            jsonDecode((await RAM.read("currentWorkout"))!))
        .map((e) => WorkoutModel.fromMap(e))
        .toList();

    // Add Pausas
    for (int i = 1; i <= workouts.length; i += 2)
      workouts.insert(
        i,
        WorkoutModel(
          title: "Pausa",
          duration: int.tryParse(exerciseIntervalController.text) ?? 0,
        ),
      );
    workouts.removeLast();
    workouts.add(
      WorkoutModel(
        title: "Pausa",
        duration: int.tryParse(seriesIntervalController.text) ?? 0,
      ),
    );

    // Multiplica
    for (int i = 1; i < (int.tryParse(seriesCountController.text) ?? 0); i++)
      workouts.addAll(workouts);
    workouts.removeLast();

    await RAM.write(
        "currentWorkout", jsonEncode(workouts.map((e) => e.toMap()).toList()));
    Navigator.pushReplacementNamed(context, "/workouttimer-run");
  }

  Widget itemField(String label, TextEditingController controller) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label + ':'),
          Container(
            height: 30,
            width: 30,
            child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (String text) => onChanged(controller)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 250,
        width: 250,
        padding: EdgeInsets.all(10),
        child: Form(
          child: Container(
            child: Column(
              children: [
                itemField(
                    "Intervalo entre exercícios", exerciseIntervalController),
                itemField("Intervalo entre séries", seriesIntervalController),
                itemField("N° de séries", seriesCountController),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancelar"),
                    ),
                    ElevatedButton(onPressed: saveAndPop, child: Text("Ir")),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
