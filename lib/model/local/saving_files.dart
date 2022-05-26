part of "../repository/database_repo.dart";

const String _myDirectory = "Shop App";
const String _myExtension = "men";
const String _myFileName = "Shop_Data";

class DataBaseFileHandling {
  Future<Database?> importDataBase(String path) async {
    FilePickerResult? value = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: [_myExtension]);
    if (value != null && value.files.isNotEmpty) {
      final Uint8List bytes = value.files.first.bytes!;
      File(path).writeAsBytes(bytes);
      return openDatabase(path);
    }
    return null;
  }

  Future<void> exportDataBase(Database dataBase) async {
    {
      if (await Permission.storage.request().isGranted) {
        String newPath = await _findPath();
        Directory dir = Directory(newPath);
        if (await dir.exists()) {
          File saveFile = File('$_myFileName.$_myExtension');
          saveFile.copy(dataBase.path);
        } else {
          Directory(newPath).create().then((value) {
            File saveFile = File('$_myFileName.$_myExtension');
            saveFile.copy(dataBase.path);
          });
        }
      } else {
        throw Exception('Permission Denied');
      }
    }
  }

  Future<String> _findPath() async {
    Directory? dir = await getExternalStorageDirectory();

    String newPath = "";
    List<String> folders = dir!.path.split("/");
    for (int x = 1; x < folders.length; x++) {
      if (folders[x] != 'Android') {
        newPath += "/" + folders[x];
      } else {
        break;
      }
    }
    newPath = newPath + "/$_myDirectory";

    return newPath;
  }
}
