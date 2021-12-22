import 'package:flutter/material.dart';
import 'package:sql_treino/shared/widgets/errorScreen.dart';
import 'package:sql_treino/shared/widgets/loadingScreen.dart';

Widget Function(BuildContext, AsyncSnapshot) buildFuture(
    Widget Function() builder) {
  Widget function(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.done:
        if (snapshot.hasError) return errorScreen();
        return builder();
      default:
        return loadingScreen();
    }
  }

  return function;
}
