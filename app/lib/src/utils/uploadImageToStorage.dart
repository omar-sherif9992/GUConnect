import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadImageToStorage(
    File imageFile, String collectionName, String fileName) async {
  // Upload image
  final storageRef = FirebaseStorage.instance
      .ref()
      .child(collectionName)
      .child(fileName + (fileName.endsWith('.jpg') ? '' : '.jpg'));

  await storageRef.putFile(imageFile);

  final String imageUrl = await storageRef.getDownloadURL();

  return imageUrl;
}
