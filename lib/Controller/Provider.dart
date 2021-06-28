import 'package:flutter/material.dart';
import 'package:flutter_todos/View/Stats.dart';
import 'package:flutter_todos/View/Todos.dart';
import '../Modle/ListTodos.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class MyModel with ChangeNotifier {
  //dùng change Notifier

  String selectedItem = 'Show all';
  String selectedItemMake = 'Make all completed';
  int countActive;
  int countComplete;
  int selectFarg = 0;

  List<ListTodos> listTodos;

  // = [
  //   ListTodos(
  //       id: 0, check: 1, title: 'Show Active - 1', detail: 'Show Completed'),
  //   ListTodos(
  //       id: 1, check: 0, title: 'Show Active -2', detail: 'Show Completed'),
  //   ListTodos(
  //       id: 2, check: 1, title: 'Show Active - 3', detail: 'Show Completed'),
  //   ListTodos(
  //       id: 3, check: 0, title: 'Show Active - 4', detail: 'Show Completed'),
  //   ListTodos(
  //       id: 4, check: 1, title: 'Show Active - 5', detail: 'Show Completed'),
  // ];

  // ============================= Database ===================================

  Database db;

  Future<List<ListTodos>> lists() async {
    // WidgetsFlutterBinding.ensureInitialized();
    // final Future<Database> database = openDatabase(join(await getDatabasesPath(), 'doggie_database.db'),);
    // Get a reference to the database.
   db = await openDatabase(
      join((await getTemporaryDirectory()).path, 'Todos_database.db'),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE listTodos (id INTEGER PRIMARY KEY, checkTodos INTEGER, title TEXT, detail TEXT )");
      },
      version: 1,
    );
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('listTodos');
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return ListTodos(
        id: maps[i]['id'],
        check: maps[i]['checkTodos'],
        title: maps[i]['title'],
        detail: maps[i]['detail'],
      );
    });
  }

  Future<void> insertListTodos(ListTodos listTodos) async {
    await db.insert(
      'listTodos',
      listTodos.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateListTodos(ListTodos listTodos) async {
    // Update the given Dog.
    await db.update(
      'listTodos',
      listTodos.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [listTodos.id],
    );
  }

  Future<void> deleteListTodos(int id) async {
    await db.delete(
      'listTodos',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  // ============================  Finish Database ==========================
  List<ListTodos> listTodosShowActive = [];

  void onItemTapped(int index) {
    selectFarg = index;
    notifyListeners();
  }

  List<Widget> widgetOptions = <Widget>[
    FragTodos(),
    FragStats(),
  ];

  void reloadList() {
    widgetOptions = <Widget>[
      FragTodos(),
      FragStats(),
    ];
    notifyListeners();
  }

  void delete(int postion) async {
    // listTodos.removeAt(postion);
    await deleteListTodos(listTodos[postion].id);
    showList();
    notifyListeners();
  }

  void checkBox(int checkBox, int postion) async {
    listTodosShowActive[postion].check = checkBox;
    await updateListTodos(listTodosShowActive[postion]);
    showList();
    notifyListeners();
  }

  void completed() async {
    selectedItem = 'Show all';
    if (selectedItemMake == 'Make all completed') {
      listTodosShowActive = [];
      for (int i = 0; i < listTodos.length; i++) {
        if (listTodos[i].check == 0) {
          listTodos[i].check = 1;
          await updateListTodos(listTodos[i]);
        }
      }
      listTodosShowActive = listTodos;
    } else {
      listTodosShowActive = [];
      for (int i = 0; i < listTodos.length; i++) {
        if (listTodos[i].check == 1) {
          await deleteListTodos(listTodos[i].id);
          // listTodosShowActive.add(listTodos[i]);
        }
      }
    }
    showList();
    notifyListeners();
  }

  void Edit(int postion, String title, String detail) async {
    listTodos[postion].title = title;
    listTodos[postion].detail = detail;
    listTodos[postion].check = 0;
    await updateListTodos(listTodos[postion]);
    showList();
    notifyListeners();
  }

  void Add(String title, String detail) async {
    // listTodos.add(new ListTodos(
    //     id: listTodos.length + 1, check: 0, title: title, detail: detail));
    await insertListTodos(
        new ListTodos(check: 0, title: title, detail: detail));
    showList();
    notifyListeners();
  }

  void Undo(int postion, int check, String title, String detail) async {
    // listTodos.insert(postion,
    //     new ListTodos(id: postion, check: check, title: title, detail: detail));
    await insertListTodos(new ListTodos(
        id: postion + 1, check: check, title: title, detail: detail));
    showList();
    notifyListeners();
  }

  void showList() async {
    listTodos = await lists();
    countComplete = 0;
    countActive = 0;
    if (selectedItem == 'Show all') {
      listTodosShowActive = listTodos;
      for (int i = 0; i < listTodos.length; i++) {
        if (listTodos[i].check == 0) {
          countActive++;
        }
      }
      countComplete = listTodos.length - countActive;
    } else if (selectedItem == 'Show Active') {
      listTodosShowActive = [];
      for (int i = 0; i < listTodos.length; i++) {
        if (listTodos[i].check == 0) {
          countActive++;
          listTodosShowActive.add(listTodos[i]);
        }
      }
      countComplete = listTodos.length - countActive;
    } else {
      listTodosShowActive = [];
      for (int i = 0; i < listTodos.length; i++) {
        if (listTodos[i].check == 1) {
          countComplete++;
          listTodosShowActive.add(listTodos[i]);
        }
      }
      countActive = listTodos.length - countComplete;
    }
    notifyListeners();
  }

  notifyListeners();
}
