class Student {
  late String id;

  Student.fromJson(Map<String, dynamic> data) {
    id = data['id'];
  }

  List get getProps => [id];
}
