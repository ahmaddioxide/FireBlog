import 'dart:io';
import 'package:fireblog/views/content_input_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreateBlogProvider extends ChangeNotifier {
  late TextEditingController titleController;
  File? selectedImage;
  String? currentUserUid;
  final picker = ImagePicker();
  final formKey = GlobalKey<FormState>();

  CreateBlogProvider() {
    titleController = TextEditingController();
    selectedImage = null; // Initialize with null value
    _getCurrentUserUid();
  }

  @override
  void dispose() {
    titleController.dispose();
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
      imageQuality: 80,
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

      final uploadTask = storageRef.putFile(selectedImage!);
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

    final title = titleController.text.trim();

    final imageUrl = await uploadImageToFirebase();

    final blogPost = {
      'title': title,
      'authorUid': currentUserUid,
      'imageUrl': imageUrl,
    };

    try {
      final DocumentReference docRef =
      await FirebaseFirestore.instance.collection('blogPosts').add(blogPost);
      final blogId = docRef.id.toString();

      // Blog post created successfully, navigate to ContentInput with blogId
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ContentInput(blogId: blogId)),
      );
    } catch (e) {
      // Error occurred while creating the blog post
      print('Error creating blog post: $e');
    }
  }
}
