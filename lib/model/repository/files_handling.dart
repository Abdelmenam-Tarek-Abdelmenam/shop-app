part of 'database_repo.dart';

const String _myDirectory = "Shop App";
const String _myExtension = "men";
const String _myFileName = "Shop_Data";

class DbFileHandling {
  Future<Database?> importDataBase() async {
    FilePickerResult? value = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: [_myExtension]);
    if (value != null && value.files.isNotEmpty) {
      final Uint8List bytes = value.files.first.bytes!;
      File(DataBaseRepository.instance.dataBasePath).writeAsBytes(bytes);
      return openDatabase(DataBaseRepository.instance.dataBasePath);
    }
    return null;
  }

  Future<void> exportDataBase() async {
    {
      if (await Permission.storage.request().isGranted) {
        String newPath = await _findPath();
        Directory dir = Directory(newPath);
        if (await dir.exists()) {
          File saveFile = File('$_myFileName.$_myExtension');
          saveFile.copy(DataBaseRepository.instance.dataBasePath);
        } else {
          Directory(newPath).create().then((value) {
            File saveFile = File('$_myFileName.$_myExtension');
            saveFile.copy(DataBaseRepository.instance.dataBasePath);
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

class ImageFileHandling {
  Future<Uint8List?> pickImage(BuildContext context) async {
    ImageSource? source = await _getImageSource(context);
    if (source == null) return null;
    final XFile? image = await ImagePicker().pickImage(source: source);
    if (image == null) return null;

    // String encoded = DataEncoding.encode(Uint8List);
    // print("Encoded Image Length: ${encoded.length}");
    // Uint8List.fromList(List<int>.from(DataEncoding.decode(encoded)));

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
