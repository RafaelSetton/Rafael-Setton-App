import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sql_treino/shared/models/workoutModel.dart';
import 'package:sql_treino/shared/globals.dart' as globals;

class SelectionDialog extends StatefulWidget {
  const SelectionDialog({Key? key}) : super(key: key);

  @override
  _SelectionDialogState createState() => _SelectionDialogState();
}

class _SelectionDialogState extends State<SelectionDialog> {
  TextEditingController exerciseIntervalCtrl =
      TextEditingController(text: "10");
  TextEditingController seriesIntervalCtrl = TextEditingController(text: "20");
  TextEditingController seriesCountCtrl = TextEditingController(text: "1");

  void onChanged(TextEditingController controller) {
    if (controller.text.isEmpty)
      controller.text = "0";
    else if (controller.text.length > 1 && controller.text.startsWith("0"))
      controller.text = controller.text.substring(1);
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
  }

  void saveAndPop() async {
    WorkoutModel workouts = globals.arguments as WorkoutModel;

    // Add Pausas
    for (int i = 1; i <= workouts.workouts.length; i += 2)
      workouts.workouts.insert(
        i,
        ExerciseModel(
          title: "Pausa",
          duration: int.tryParse(exerciseIntervalCtrl.text) ?? 0,
        ),
      );
    workouts.workouts.removeLast();
    workouts.workouts.add(
      ExerciseModel(
        title: "Pausa",
        duration: int.tryParse(seriesIntervalCtrl.text) ?? 0,
      ),
    );

    // Multiplica
    for (int i = 1; i < (int.tryParse(seriesCountCtrl.text) ?? 0); i++)
      workouts.workouts.addAll(workouts.workouts.toList());
    workouts.workouts.removeLast();

    globals.arguments = workouts;
    Navigator.pushReplacementNamed(context, "/workouttimer-run");
  }

  Widget itemField(String label, TextEditingController controller) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
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
            width: 60,
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
                itemField("Intervalo entre exercícios", exerciseIntervalCtrl),
                itemField("Intervalo entre séries", seriesIntervalCtrl),
                itemField("N° de séries", seriesCountCtrl),
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
