class Todo {
  Todo(this._title, this._isDone);
  Todo.withId(this._id, this._title, this._isDone);

  int _id;
  String _title;
  bool _isDone;

  int get id => _id;
  String get title => _title;
  bool get isDone => _isDone;

  set id(int id) {
    this._id = id;
  }

  set title(String title) {
    this._title = title;
  }

  set isDone(bool isDone) {
    this._isDone = isDone;
  }

  // Convert to map object for sqlite
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['title'] = _title;
    map['isDone'] = _isDone ? 1 : 0;

    if (_id != null) {
      map['id'] = _id;
    }
    return map;
  }

  Todo.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._isDone = map['isDone'] == 1 ? true : false;
  }
}
