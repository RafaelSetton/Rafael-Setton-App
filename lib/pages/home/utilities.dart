import 'package:sql_treino/pages/home/selection.dart';
import 'package:sql_treino/pages/home/navButton.dart';

class UtilitiesScreen extends SelectionScreen {
  @override
  List<NavButton> get buttons => [
        NavButton(text: "Calculadora", routeName: "calculator"),
        NavButton(text: "Cálculo de IMC", routeName: "calculodeimc"),
        NavButton(text: "Conversor de Moedas", routeName: "conversordemoedas"),
        NavButton(text: "Todo List", routeName: "todolist"),
        NavButton(text: "Workout Timer", routeName: "workouttimer-edit"),
        NavButton(text: "Chat App", routeName: "chatlist"),
      ];
}
