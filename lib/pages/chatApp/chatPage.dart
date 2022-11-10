import 'package:flutter/material.dart';
import 'package:sql_treino/pages/chatApp/helpers/messageRenderer.dart';
import 'package:sql_treino/services/storage.dart';
import 'package:sql_treino/shared/functions/buildFuture.dart';
import 'package:sql_treino/shared/models/chatModel.dart';
import 'package:sql_treino/shared/models/messageModel.dart';
import 'package:sql_treino/shared/models/userModel.dart';
import 'package:sql_treino/shared/globals.dart' as globals;

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatModel data;
  UserModel? user;
  TextEditingController messageTextController = TextEditingController();

  void sendMessage() {
    if (messageTextController.text.isEmpty) return;
    data.messages.add(MessageModel(
      senderEmail: user!.email,
      chatID: data.id,
      content: messageTextController.text,
    ));
    ChatAppDB.postChat(data);
    setState(() {
      messageTextController.text = "";
    });
  }

  Widget messageField() {
    return SizedBox(
      height: 60,
      width: 300,
      child: Container(
        color: Colors.blue.shade900,
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: TextField(
                  controller: messageTextController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: sendMessage,
              child: Icon(Icons.send),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget builder() {
    MessageRenderer renderer = MessageRenderer(user!);
    List<Widget> children =
        data.messages.map((e) => renderer.build(context, e)).toList();
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: BackButton(),
          title: Text(data.title),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(child: Container()),
              SingleChildScrollView(
                child: Column(
                  children: children,
                ),
                reverse: true,
              ),
            ],
          ),
        ),
        bottomNavigationBar: messageField(),
      ),
    );
  }

  Future<void> loadData() async {
    user = (await UserDB.show(globals.userEmail))!;
  }

  @override
  Widget build(BuildContext context) {
    data = globals.arguments as ChatModel;

    if (user == null)
      return FutureBuilder(
        builder: buildFuture(builder),
        future: loadData(),
      );
    return builder();
  }
}
