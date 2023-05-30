import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreateBlog extends StatefulWidget {
  const CreateBlog({Key? key}) : super(key: key);

  @override
  State<CreateBlog> createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late File? _selectedImage;
  String? _currentUserUid;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _selectedImage = null; // Initialize with null value
    _getCurrentUserUid();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentUserUid() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _currentUserUid = user.uid;
      });
    }
  }

  Future<void> _getImageFromGallery() async {
    final pickedImage =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<String?> _uploadImageToFirebase() async {
    if (_selectedImage == null) {
      return null;
    }

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('blog_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      final uploadTask = storageRef.putFile(_selectedImage!);
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

  Future<void> _createBlogPost() async {
    if (_currentUserUid == null) {
      // User not logged in or UID not available
      return;
    }

    if (!_formKey.currentState!.validate()) {
      // Form validation failed
      return;
    }

    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    final imageUrl = await _uploadImageToFirebase();

    final blogPost = {
      'title': title,
      'content': content,
      'authorUid': _currentUserUid,
      'imageUrl': imageUrl,
    };

    try {
      await FirebaseFirestore.instance.collection('blogPosts').add(blogPost);
      // Blog post created successfully, do something (e.g., navigate to another screen)
    } catch (e) {
      // Error occurred while creating the blog post
      print('Error creating blog post: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Blog'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _getImageFromGallery,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                    image: _selectedImage != null
                        ? DecorationImage(
                      image: FileImage(_selectedImage!),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: _selectedImage == null
                      ? Icon(
                    Icons.camera_alt,
                    size: 40,
                    color: Colors.grey[600],
                  )
                      : null,
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _contentController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _createBlogPost,
                child: const Text('Create Blog Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
