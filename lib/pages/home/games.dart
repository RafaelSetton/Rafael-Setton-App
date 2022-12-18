import 'package:sql_treino/pages/home/selection.dart';
import 'package:sql_treino/pages/home/navButton.dart';

class GamesScreen extends SelectionScreen {
  @override
  List<NavButton> get buttons => [
        NavButton(
          text: "Color Game",
          routeName: "colorgame",
        ),
        NavButton(
          text: "Somando Saber",
          routeName: "somando-saber",
        ),
      ];
}
