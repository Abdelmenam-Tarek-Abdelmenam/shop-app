import 'package:sqflite/sqflite.dart';

part '../contstants/database_schema.dart';

class DataBaseRepository {
  late Database _database;

  DataBaseRepository() {
    _init();
  }

  void _init() {
    print(_TablesSchema.all);
  }

  Future<void> dispose() async => await _database.close();

  Future<void> delete() async {
    for (String name in _TablesName.all) {
      await _database.delete(name);
    }
  }
}
