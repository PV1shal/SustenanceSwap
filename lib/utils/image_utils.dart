import 'dart:io';
import 'package:image/image.dart' as image_package;

/// The function returns the compressed image file
Future<File> compressImage(String fileName, File image) async {
  final temporaryDir = Directory.systemTemp;
  final path = temporaryDir.path;

  return await _compressGivenImage({
    "fileName": fileName,
    "path": path,
    "imageBytes": image.readAsBytesSync(),
  });
}

/// The _compressGivenImage function takes a Map<String, dynamic> argument that contains the required data for image compression
Future<File> _compressGivenImage(Map<String, dynamic> data) async {
  final fileName = data["fileName"];
  final path = data["path"];
  final imageBytes = data["imageBytes"];

  image_package.Image? imageFile = image_package.decodeImage(imageBytes);
  final compressedImageFile = File("$path/$fileName")
    ..writeAsBytesSync(image_package.encodeJpg(imageFile!, quality: 75));

  return compressedImageFile;
}
