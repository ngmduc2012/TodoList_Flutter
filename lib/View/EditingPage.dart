import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Controller/Provider.dart';
import 'AddandEdit.dart';
import '../Modle/ListTodos.dart';

class EditingPage extends StatelessWidget {
  final int postion;
  bool check;

  // In the constructor, require a Todo
  EditingPage(this.postion);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<MyModel>(
      builder: (context, mymodel, child) {
        if( mymodel.listTodosShowActive[postion].check == 1){
          check = true;
        }
        else
          {
            check = false;
          }
        return Scaffold(
          backgroundColor: Colors.black38,
          appBar: AppBar(
            title: Text(
              "Detail Note",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                tooltip: "Delete",
                icon: Icon(Icons.delete),
                onPressed: () {
                  mymodel.delete(postion);
                  Navigator.pop(context);
                },
              )
            ],
            backgroundColor: Colors.black87,
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor: Colors.white,
                        ),
                        child: Checkbox(
                            value: check,
                            onChanged: (newValue) {
                              if(newValue){
                                mymodel.checkBox(1, postion);
                              }
                              else{
                                mymodel.checkBox(0, postion);
                              }
                            }),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(
                              top: 8.0,
                              bottom: 16.0,
                            ),
                            child: Text(
                              "${mymodel.listTodosShowActive[postion].title}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                          Text(
                            "${mymodel.listTodosShowActive[postion].detail}",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddEditScreen(
                        "Edit", postion)),
              );
            },
          ),
        );
      },
    );
  }
}
