import 'package:flutter/material.dart';
import '../Modle/ListTodos.dart';
import 'package:provider/provider.dart';
import 'main.dart';

import '../Controller/Provider.dart';

class AddEditScreen extends StatefulWidget {
  // truyền giá trị vào stateful
  String nameAction;
  int postion;

  AddEditScreen(this.nameAction, this.postion);

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  TextEditingController myController = new TextEditingController();
  TextEditingController myControllerDetail = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<MyModel>(
      // khi notifi thông báo giá trị thay đổi thì các biến trong consumer sẽ thay đổi theo
      builder: (context, mymodel, child) {
        if (widget.nameAction == "Add") {
          myController.text = "";
          myControllerDetail.text = "";
        } else {
          myController.text =  mymodel.listTodosShowActive[widget.postion].title;
          myControllerDetail.text =  mymodel.listTodosShowActive[widget.postion].detail;
        }
        return Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(
            backgroundColor: Colors.black54,
            title: Text(
              '${widget.nameAction}',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              child: ListView(
                children: [
                  TextField(
                    textAlign: TextAlign.start,
                    controller: myController,
                    style: TextStyle(color: Colors.white),
                    // onChanged: (String value) {
                    //   myController.text = value;
                    // },
                  ),
                  TextFormField(
                    textAlign: TextAlign.start,
                    controller: myControllerDetail,
                    maxLines: 10,
                    style: TextStyle(color: Colors.white),
                    // onChanged: (String value) {
                    //   myControllerDetail.text = value;
                    // },
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.check),
            onPressed: () {
              // print(widget.nameAction);
              // print(myController.text);
              if (widget.nameAction == "Add") {
                mymodel.Add(myController.text, myControllerDetail.text);
              } else {
                mymodel.Edit(
                    widget.postion, myController.text, myControllerDetail.text);
              }
              // main();
              // print("ok");
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
