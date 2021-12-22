import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sql_treino/services/database/storage.dart';

class FirebaseImageHandler {
  final FirebaseStorage connection;
  final picker = ImagePicker();
  File? _imageFile;

  FirebaseImageHandler(FirebaseApp firebaseApp)
      : connection = FirebaseStorage.instanceFor(app: firebaseApp);

  Future _pickImage() async {
    // TODO: Choose from gallery;
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    _imageFile = pickedFile == null ? null : File(pickedFile.path);
  }

  Future<UploadTask?> _uploadImageToFirebase() async {
    if (_imageFile == null) return null;
    String fileName =
        WorkoutDB.userEmail + DateTime.now().millisecondsSinceEpoch.toString();
    Reference firebaseStorageRef = connection.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile!);
    return await Future.value(uploadTask);
  }

  Future<String?> upload() async {
    await _pickImage();
    UploadTask? task = await _uploadImageToFirebase();
    return task?.snapshot.ref.fullPath;
  }

  Future delete(String path) async {
    await connection.refFromURL(path).delete();
  }
}
