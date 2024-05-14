import 'dart:io';
import 'dart:typed_data';
import'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
String removeSubString(String string, String subString) {
  String escapedSubstring = RegExp.escape(subString);
  RegExp pattern = RegExp(escapedSubstring);

  if (pattern.hasMatch(string)) {
    return string.replaceAll(pattern, '');
  } else {
    return string;
  }
}
double getHeight(context) {
  return MediaQuery.of(context).size.height;
}
double getWidth(context) {
  return MediaQuery.of(context).size.width;
}



Future<File> compressImage(File file) async {
  // Define the maximum width and height for the compressed image
  int maxWidth = 1024;
  int maxHeight = 1024;

  // Read the image file as a Uint8List
  Uint8List imageData = Uint8List.fromList(await file.readAsBytes());

  // Compress the image
  List<int> compressedImageData = await FlutterImageCompress.compressWithList(
    imageData,
    minHeight: 400, // optional, set the minimum height of the image
    minWidth: 500, // optional, set the minimum width of the image
    quality: 50, // set the quality of the compressed image (0 to 100)
    rotate: 0, // set the rotation angle of the image
    format: CompressFormat.jpeg, // set the format of the compressed image
  );

  // Create a new File object with the compressed image data
  File compressedFile = File(file.path)
    ..writeAsBytesSync(compressedImageData);

  return compressedFile;
}