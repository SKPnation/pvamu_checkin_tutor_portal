import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:html' as html;
import 'dart:typed_data';

class WebImageUploader {
  static final _picker = ImagePicker();

  /// Picks an image (web) and uploads to Firebase Storage.
  /// Returns the download URL.
  static Future<Uint8List?> pickImageBytesWeb() async {
    final uploadInput = html.FileUploadInputElement()
      ..accept = 'image/*';
    uploadInput.click();

    await uploadInput.onChange.first;

    final file = uploadInput.files?.first;

    if (file == null) return null;

    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    await reader.onLoadEnd.first;

    print("FILE: ${reader.onLoadEnd.first}");


    return reader.result as Uint8List;
  }

  static Future<String?> uploadImage({
    required Uint8List bytes,
    required String folder,
    String extension = 'jpg',
  }) async {
    final fileName = "${DateTime.now().millisecondsSinceEpoch}.$extension";

    print("file name: $fileName");


    final ref = FirebaseStorage.instance.ref('$folder/$fileName');

    print("reference: $ref");

    final task = ref.putData(
      bytes,
      SettableMetadata(contentType: "image/jpeg"),
    );

    final snap = await task;

    print("Upload state: ${snap.state}"); // should be TaskState.success

    final downloadUrl = await ref.getDownloadURL();
    print("download url: $downloadUrl");
    return downloadUrl;
  }
}
