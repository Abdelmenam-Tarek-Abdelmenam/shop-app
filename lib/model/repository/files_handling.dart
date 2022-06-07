part of 'database_repo.dart';

const String _myDirectory = "Shop App/";
const String _myExtension = "sh";
const String _myFileName = "Shop_Data";

class DbFileHandling {
  Future<bool> importDataBase() async {
    FilePickerResult? value = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [_myExtension],
        withData: true);
    if (value != null && value.files.isNotEmpty) {
      File file = File(value.files.first.path!);
      String data = file.readAsStringSync();
      print(file.readAsBytesSync());
      print(data);
      Map<String, dynamic> dataMap = DataEncoding.decode(data);
      DataBaseRepository.instance.fromJson(dataMap);
      return true;
    }
    return false;
  }

  Future<void> exportDataBase() async {
    File file = await _getNewFile('$_myFileName.$_myExtension');
    Map<String, ReturnedData> data =
        await DataBaseRepository.instance.getAllData();
    print(data);
    String encoded = DataEncoding.encode(data);
    print(encoded);
    file.writeAsStringSync(encoded);
    await DataBaseRepository.instance.initializeDatabase();
  }

  Future<void> saveCsv(ReturnedData data, String name) async {
    File file = await _getNewFile('$name${DateTime.now()}.csv');
    file.writeAsString(data.toCsv);
  }

  Future<File> _getNewFile(String fileName) async {
    if (await Permission.storage.request().isGranted) {
      String newPath = await _findPath();
      Directory dir = Directory(newPath);
      if (await dir.exists()) {
        File saveFile = File(newPath + fileName);
        return saveFile;
      } else {
        await Directory(newPath).create();
        File saveFile = File(newPath + fileName);
        return saveFile;
      }
    } else {
      throw Exception('Permission Denied');
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
    print(newPath);
    newPath = newPath + "/$_myDirectory";
    return newPath;
  }
}

class ImageFileHandling {
  Future<Uint8List?> pickImage(BuildContext context) async {
    ImageSource? source = await _getImageSource(context);
    if (source == null) return null;
    final XFile? image = await ImagePicker().pickImage(source: source);
    if (image == null) return null;

    return compressImage(image);
  }

  Future<Uint8List?> compressImage(XFile file) async {
    String programPath = (await getTemporaryDirectory()).path;
    File? result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      "$programPath/output.jpg",
      quality: 50,
    );

    return result?.readAsBytes();
  }

  Future<ImageSource?> _getImageSource(BuildContext context) async {
    return await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (_) => Container(
              margin: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _button(context, "Gallery", Icons.photo_outlined,
                      ImageSource.gallery),
                  const SizedBox(
                    width: 10,
                  ),
                  _button(context, "Camera", Icons.photo_camera_outlined,
                      ImageSource.camera),
                ],
              ),
            ));
  }

  Widget _button(BuildContext context, String text, IconData icon,
          ImageSource source) =>
      OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
        ),
        label: Text(text),
        onPressed: () => Navigator.pop(context, source),
        icon: Icon(
          icon,
          size: 20,
        ),
      );
}

extension CSV on ReturnedData {
  String get toCsv {
    if (isEmpty) return "";
    String csv = '';
    csv += this[0].keys.join(',') + '\n';
    for (Map<String, dynamic> element in this) {
      csv += element.values.join(',') + '\n';
    }
    return csv;
  }
}
