import 'package:flutter/material.dart';
import 'package:sql_treino/pages/chatApp/helpers/firebaseImageHandler.dart';
import 'package:sql_treino/services/storage.dart';
import 'package:sql_treino/shared/models/argumentsModel.dart';
import 'package:sql_treino/shared/models/chatModel.dart';

class ImageDialog extends StatelessWidget {
  final ChatModel chat;
  final ArgumentsModel arguments;

  const ImageDialog({Key? key, required this.chat, required this.arguments})
      : super(key: key);

  Widget navigationButton(
      {required Icon icon, required void Function() onPressed}) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(width: 0.5),
          color: Colors.grey.shade300,
        ),
        child: TextButton(
          onPressed: onPressed,
          child: icon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: Image.network(chat.imgURL ?? " "),
            ),
          ), // TODO: Image
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              navigationButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 40,
                ),
              ),
              navigationButton(
                onPressed: () async {
                  FirebaseImageHandler handler =
                      FirebaseImageHandler(arguments.firebaseApp);

                  String? downloadURL = (await handler.upload())
                      ?.replaceAll("/", "%2F")
                      .replaceAll("@", "%40");
                  if (downloadURL == null) return;

                  String? previousImageURL = chat.imgURL;
                  print(downloadURL);
                  chat.imgURL =
                      "https://firebasestorage.googleapis.com/v0/b/rafael-setton-project.appspot.com/o/$downloadURL?alt=media";
                  await ChatAppDB.postChat(chat);

                  if (previousImageURL != null)
                    handler.delete(previousImageURL);
                },
                icon: Icon(
                  Icons.add_a_photo,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
