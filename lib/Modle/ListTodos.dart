class ListTodos {
  int id;
  int check;
  String title;
  String detail;

  ListTodos({this.id, this.check, this.title, this.detail});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'checkTodos': check,
      'title': title,
      'detail': detail,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'listTodos{id: $id, checkTodos: $check, title: $title , detail: $detail}';
  }
}
