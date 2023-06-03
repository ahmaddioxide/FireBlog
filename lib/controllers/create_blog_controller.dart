import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../views/content_input_screen.dart';

class CreateBlogProvider extends ChangeNotifier {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  File? selectedImage;
  String? currentUserUid;
  final picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  double uploadProgress = 0.0;
  Stream<double> uploadProgressStream = const Stream.empty();

  CreateBlogProvider() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    selectedImage = null; // Initialize with null value
    _getCurrentUserUid();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentUserUid() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUserUid = user.uid;
    }
  }

  Future<void> getImageFromGallery() async {
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedImage != null) {
      selectedImage = File(pickedImage.path);
    }
    notifyListeners();
  }

  Future<String?> uploadImageToFirebase() async {
    if (selectedImage == null) {
      return null;
    }

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('blog_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      final uploadTask = storageRef.putFile(
        selectedImage!,
        // Add listener to track upload progress
        SettableMetadata(
          contentType: 'image/jpeg',
        ),
      );

      // Get the upload progress stream
      uploadProgressStream = uploadTask.snapshotEvents.map(
            (TaskSnapshot snapshot) => snapshot.bytesTransferred / snapshot.totalBytes,
      );

      final taskSnapshot = await uploadTask.whenComplete(() {});

      if (taskSnapshot.state == TaskState.success) {
        final imageUrl = await storageRef.getDownloadURL();
        return imageUrl;
      }
    } catch (e) {
      print('Error uploading image to Firebase: $e');
    }

    return null;
  }

  Future<void> createBlogPost(BuildContext context) async {
    if (currentUserUid == null) {
      // User not logged in or UID not available
      return;
    }

    if (!formKey.currentState!.validate()) {
      // Form validation failed
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SpinKitWave(color: Colors.brown, size: 32.0),
                SizedBox(height: 16.0),
                Text('Creating Blog Post...'),
              ],
            ),
          ),
        );
      },
    );

    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    final imageUrl = await uploadImageToFirebase();

    final blogPost = {
      'title': title,
      'description': description,
      'authorUid': currentUserUid,
      'imageUrl': imageUrl,
    };

    try {
      final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .get();

      final int currentBlogsPublished = (userSnapshot.data() as Map<String, dynamic>?)?['blogsPublished'] ?? 0;
      final int updatedBlogsPublished = currentBlogsPublished + 1;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .update({'blogsPublished': updatedBlogsPublished});

      final DocumentReference blogRef = await FirebaseFirestore.instance.collection('blogPosts').add(blogPost);
      final String blogId = blogRef.id;
      // Blog post created successfully, navigate to ContentInput with blogId
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ContentInput(blogId: blogId)),
      );
    } catch (e) {
      // Error occurred while creating the blog post
      print('Error creating blog post: $e');
    }
  }
}
