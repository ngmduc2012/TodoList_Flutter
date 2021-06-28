import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Modle/ListTodos.dart';
import '../Controller/Provider.dart';
import 'main.dart';
import 'EditingPage.dart';

class FragTodos extends StatefulWidget {
  @override
  FragTodosState createState() => FragTodosState();
}

class FragTodosState extends State<FragTodos> {
  bool  intCheck;
  int saveCheck;
  String saveTitle;
  String saveDetail;

  @override
  Widget build(BuildContext context) {
    return Consumer<MyModel>(
      builder: (context, mymodel, child) {
        return ListView.builder(
          itemCount: mymodel.listTodosShowActive.length,
          itemBuilder: (context, postion) {
            if(mymodel.listTodosShowActive[postion].check == 1){
                intCheck = true;
            }
            else
              {
                intCheck = false;
              }
            return Dismissible(
              // put left and right for delete
              background: Container(color: Colors.indigoAccent),
              key: Key(mymodel.listTodosShowActive[postion].title),
              direction: DismissDirection.horizontal,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditingPage(
                            postion)),
                  );
                },
                title: Text(
                  '${mymodel.listTodosShowActive[postion].title}',
                  style: TextStyle(color: Colors.white),
                ),
                leading: Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor: Colors.white,
                  ),
                  child: Checkbox(
                      value: intCheck,
                      // checkColor: Colors.white,
                      onChanged: (bool newValue) {
                        if(newValue){
                          mymodel.checkBox(1, postion);
                        }
                        else{
                          mymodel.checkBox(0, postion);
                        }
                      }),
                ),
                subtitle: Text(
                  "${mymodel.listTodosShowActive[postion].detail}",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              // all your content that will be swiped away
              onDismissed: (direction) {
                saveCheck = mymodel.listTodosShowActive[postion].check;
                saveTitle = mymodel.listTodosShowActive[postion].title;
                saveDetail = mymodel.listTodosShowActive[postion].detail;
                mymodel.delete(postion);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("$saveTitle dismissed"),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: "undo",
                    onPressed: () {
                      mymodel.Undo(postion, saveCheck, saveTitle, saveDetail);
                    },
                  ),
                ));
              },
            );
          },
        );
      },
    );
  }
}
