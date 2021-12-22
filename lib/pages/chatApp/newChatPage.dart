import 'package:flutter/material.dart';
import 'package:sql_treino/services/database/storage.dart';
import 'package:sql_treino/shared/functions/getArguments.dart';
import 'package:sql_treino/shared/models/chatModel.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:sql_treino/shared/widgets/progressDialog.dart';

class NewChatPage extends StatefulWidget {
  const NewChatPage({Key? key}) : super(key: key);

  @override
  _NewChatPageState createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  int completionIndex = 0;
  static const int PAGE_COUNT = 2;
  late List<Widget Function()> pages;
  List<String> userNames = [];
  List<String> usersSelected = [];
  String? _userEmail;

  String get userEmail {
    if (_userEmail == null) _userEmail = getArguments(context)!.userEmail;
    return _userEmail!;
  }

  TextEditingController nameController = TextEditingController();
  String descriptionText = "";

  @override
  void initState() {
    super.initState();
    loadUsers();
    pages = [
      chooseNamePage,
      chooseUsersPage,
    ];
    nameController.addListener(() {
      setState(() {
        descriptionText =
            nameController.text.isEmpty ? "O nome não pode ser vazio" : "";
      });
    });
  }

  Widget chooseNamePage() {
    return Column(children: [
      TextField(
        controller: nameController,
        decoration: InputDecoration(
          hintText: "Grupo da fofoca",
          labelText: "Nome do Chat",
        ),
      ),
      SizedBox(height: 15),
      Text(
        descriptionText,
        style: TextStyle(
          fontSize: 18,
          color: Colors.red,
        ),
      ),
    ]);
  }

  Future loadUsers() async {
    userNames = await UserDB.list();
    userNames.remove(userEmail);
  }

  Widget userTile(String email) {
    Icon icon = Icon(
      Icons.person_remove_alt_1_rounded,
      color: Colors.red,
    );
    void Function() onPressed = () {
      setState(() {
        usersSelected.remove(email);
        userNames.add(email);
      });
    };

    if (email == userEmail) {
      icon = Icon(Icons.star, color: Colors.yellow);
      onPressed = () {};
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 7),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(email),
          IconButton(
            icon: icon,
            onPressed: onPressed,
          )
        ],
      ),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget chooseUsersPage() {
    List<Widget> chosen = ([userEmail] + usersSelected).map(userTile).toList();
    return Column(
      children: <Widget>[
        TypeAheadField<String>(
          itemBuilder: (BuildContext context, itemData) {
            return Text(itemData);
          },
          onSuggestionSelected: (String suggestion) {
            setState(() {
              userNames.remove(suggestion);
              usersSelected.add(suggestion);
            });
          },
          suggestionsCallback: (String pattern) {
            return userNames.where((element) => element.startsWith(pattern));
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: chosen,
            ),
          ),
        ),
      ],
    );
  }

  Widget leftArrowButton() {
    Color color = completionIndex == 0 ? Colors.grey : Colors.black;
    void Function() onPressed = completionIndex == 0
        ? () {}
        : () {
            setState(() {
              completionIndex--;
            });
          };

    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: onPressed,
      color: color,
    );
  }

  Widget rightArrowButton() {
    IconData icon = completionIndex == PAGE_COUNT - 1
        ? Icons.check
        : Icons.arrow_forward_ios;

    void Function() onPressed;
    if (descriptionText.isNotEmpty)
      onPressed = () {};
    else
      onPressed = completionIndex == PAGE_COUNT - 1
          ? submit
          : () => setState(() {
                completionIndex++;
              });

    Color color = descriptionText.isNotEmpty ? Colors.grey : Colors.black;

    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      color: color,
    );
  }

  Future submit() async {
    ChatModel chat = ChatModel(
      id: "$userEmail@${DateTime.now().millisecondsSinceEpoch}",
      messages: [],
      users: [userEmail] + usersSelected,
      title: nameController.text,
    );

    await ProgressDialog().awaitFuture(context, ChatAppDB.postChat(chat));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text("Novo Chat"),
        centerTitle: true,
      ),
      body: pages[completionIndex](),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            leftArrowButton(),
            Container(
              width: 200,
              child: LinearProgressIndicator(
                minHeight: 10,
                value: completionIndex / (PAGE_COUNT - 1),
              ),
            ),
            rightArrowButton(),
          ],
        ),
      ),
    );
  }
}
