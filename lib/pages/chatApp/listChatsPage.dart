import 'package:flutter/material.dart';
import 'package:sql_treino/pages/chatApp/helpers/imageDialog.dart';

import 'package:sql_treino/services/firebase/chatAppDB.dart';
import 'package:sql_treino/services/firebase/usersDB.dart';
import 'package:sql_treino/shared/functions/buildFuture.dart';
import 'package:sql_treino/shared/models/chatModel.dart';
import 'package:sql_treino/shared/models/messageModel.dart';
import 'package:sql_treino/shared/models/userModel.dart';
import 'package:sql_treino/shared/widgets/progressDialog.dart';
import 'package:sql_treino/shared/globals.dart' as globals;

// TODO: FIX IMAGE LOADING
class ListChatsPage extends StatefulWidget {
  const ListChatsPage({Key? key}) : super(key: key);

  @override
  _ListChatsPageState createState() => _ListChatsPageState();
}

class _ListChatsPageState extends State<ListChatsPage> {
  List<ChatModel> chats = [];

  Future deleteChat(ChatModel chat) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Container(
          width: 150,
          height: 100,
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Deseja excluir o chat '${chat.title}'?",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: Navigator.of(context).pop,
                    child: Text("Cancelar"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await ProgressDialog()
                          .awaitFuture(context, ChatAppDB.deleteChat(chat.id));
                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: Text("Excluir"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemBuilder(ChatModel chat) {
    final MessageModel lastMessage = chat.messages.length > 0
        ? chat.messages.last
        : MessageModel(
            senderEmail: "No messages in this chat",
            chatID: "",
            content: chat.id,
          );

    globals.arguments = chat;

    return TextButton(
      onLongPress: () async {
        await deleteChat(chat);
        setState(() {});
      },
      onPressed: () async {
        await Navigator.pushNamed(context, "/chat");
        setState(() {});
      },
      child: Container(
        height: 100,
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            TextButton(
              onPressed: () async => await showDialog(
                context: context,
                builder: (context) => ImageDialog(chat: chat),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: chat.imgURL != null
                        ? NetworkImage(chat.imgURL ?? "")
                        : AssetImage("lib/assets/addImage.png")
                            as ImageProvider,
                    fit: BoxFit.fill,
                  ),
                  color: Colors.grey,
                ),
                width: 50,
                height: 50,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    chat.title,
                    style: TextStyle(
                      color: Colors.blue.shade600,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      text: "${lastMessage.senderEmail}: ",
                      style: TextStyle(
                        color: Colors.indigo.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: lastMessage.content,
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget body() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: chats.map(itemBuilder).toList(),
        ),
      ),
    );
  }

  Future<List<ChatModel>> getData() async {
    UserModel user = (await UserDB.show(globals.userEmail))!;
    List<ChatModel> response = [];
    for (String id in user.data.chats)
      response.add(await ChatAppDB.getChat(id));
    this.chats = response;
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text("Chat App"),
        centerTitle: true,
      ),
      body: Container(
        child: FutureBuilder(
          builder: buildFuture(body),
          future: getData(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text(
          "+",
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w300,
          ),
        ),
        onPressed: () async {
          await Navigator.pushNamed(context, "/newchat");
          await getData();
        },
      ),
    );
  }
}
