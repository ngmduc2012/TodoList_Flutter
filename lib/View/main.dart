import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../Controller/Provider.dart';
import 'Stats.dart';
import 'Todos.dart';
import 'AddandEdit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();  // cho SQLite
  runApp(const MyApp());
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyModel>(
        // set this in head of all for provider
        create: (context) => MyModel()..lists(),  // khởi tạo hàm khi chạy ứng dụng để lấy db
        child: MaterialApp(
          title: _title,
          home: MyStatefulWidget(),
        ));
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({key}) : super(key: key);

  @override
  MyStatefulWidgetState createState() => MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class MyStatefulWidgetState extends State<MyStatefulWidget> {
  List _options = ['Show all', 'Show Active', 'Show Completed'];
  List _optionsMake = ['Make all completed', 'clear completed'];

  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<MyModel>(context, listen: false).showList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyModel>(
      // khi notifi thông báo giá trị thay đổi thì các biến trong consumer sẽ thay đổi theo
      builder: (context, mymodel, child) {
        return Scaffold(
          backgroundColor: Colors.black87,
          appBar: AppBar(
            title: const Text('Flutter todos'),
            backgroundColor: Colors.black38,
            actions: <Widget>[
              Consumer<MyModel>(
                // khi notifi thông báo giá trị thay đổi thì các biến trong consumer sẽ thay đổi theo
                builder: (context, mymodel, child) {
                  return PopupMenuButton(
                    icon: Icon(
                      Icons.filter_list,
                      color: Colors.white,
                    ),
                    color: Colors.grey,
                    itemBuilder: (BuildContext bc) {
                      return _options
                          .map((day) => PopupMenuItem(
                                child: day == mymodel.selectedItem
                                    ? Text(
                                        day,
                                        style:
                                            TextStyle(color: Colors.blueAccent),
                                      )
                                    : Text(day,
                                        style: TextStyle(color: Colors.white)),
                                value: day,
                              ))
                          .toList();
                    },
                    onSelected: (value) {
                      setState(() {
                        mymodel.selectedItem = value;
                        mymodel.showList();
                        mymodel.reloadList();
                      });
                    },
                  );
                },
              ),
              Consumer<MyModel>(
                // khi notifi thông báo giá trị thay đổi thì các biến trong consumer sẽ thay đổi theo
                builder: (context, mymodel, child) {
                  return PopupMenuButton(
                    color: Colors.grey,
                    itemBuilder: (BuildContext bc) {
                      return _optionsMake
                          .map((day) => PopupMenuItem(
                                child: Text(
                                  day,
                                  style: TextStyle(color: Colors.white),
                                ),
                                value: day,
                              ))
                          .toList();
                    },
                    onSelected: (value) {
                      setState(() {
                        mymodel.selectedItemMake = value;
                        mymodel.completed();
                        mymodel.reloadList();
                      });
                    },
                  );
                },
              ),
            ],
          ),
          body: Consumer<MyModel>(
            // khi notifi thông báo giá trị thay đổi thì các biến trong consumer sẽ thay đổi theo
            builder: (context, mymodel, child) {
              return Center(
                child: mymodel.widgetOptions.elementAt(mymodel.selectFarg),
              );
            },
          ),
          bottomNavigationBar: Consumer<MyModel>(
            // khi notifi thông báo giá trị thay đổi thì các biến trong consumer sẽ thay đổi theo
            builder: (context, mymodel, child) {
              return BottomNavigationBar(
                backgroundColor: Colors.black87,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.list,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.white,
                    label: 'Todos',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.show_chart, color: Colors.white),
                    label: 'Stats',
                  ),
                ],
                currentIndex: mymodel.selectFarg,
                selectedItemColor: Colors.blueAccent,
                onTap: mymodel.onItemTapped,
              );
            },
          ),
          floatingActionButton:
          Consumer<MyModel>(
            // khi notifi thông báo giá trị thay đổi thì các biến trong consumer sẽ thay đổi theo
            builder: (context, mymodel, child) {
              return
                FloatingActionButton(
                backgroundColor: Colors.blueAccent,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddEditScreen(
                            'Add', 0)),
                  );
                },
                child: Icon(
                  Icons.add,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
