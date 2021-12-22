import 'package:flutter/material.dart';
import 'package:sql_treino/shared/models/argumentsModel.dart';

ArgumentsModel? getArguments(BuildContext context) =>
    ModalRoute.of(context)!.settings.arguments as ArgumentsModel;
