import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageServices {


  Future<String> uploadAndGetUrl(selectedImage) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('blog_images')
        .child('${DateTime
        .now()
        .millisecondsSinceEpoch}.jpg');

     TaskSnapshot taskSnapshot = await storageRef.putFile(
      selectedImage!,
      SettableMetadata(
        contentType: 'image/jpeg',
      ),
    ).whenComplete(() => null);

    if (taskSnapshot.state == TaskState.success) {
      final imageUrl = await storageRef.getDownloadURL();
      return imageUrl;
    }
    return '';

  }
}