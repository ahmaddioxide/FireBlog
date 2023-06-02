import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/create_blog_controller.dart';

class CreateBlog extends StatelessWidget {
  const CreateBlog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CreateBlogProvider(),
      child: CreateBlogForm(),
    );
  }
}

class CreateBlogForm extends StatefulWidget {
  @override
  _CreateBlogFormState createState() => _CreateBlogFormState();
}

class _CreateBlogFormState extends State<CreateBlogForm> {
  double uploadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<CreateBlogProvider>(context, listen: false);
    provider.uploadProgressStream.listen((progress) {
      setState(() {
        uploadProgress = progress;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CreateBlogProvider>(context);

    provider.titleController.addListener(() {
      provider.notifyListeners();
    });

    provider.descriptionController.addListener(() {
      provider.notifyListeners();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Blog'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: provider.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: provider.getImageFromGallery,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                    image: provider.selectedImage != null
                        ? DecorationImage(
                            image: FileImage(provider.selectedImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (provider.selectedImage == null)
                        Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.grey[600],
                        ),
                      if (uploadProgress > 0.0 && uploadProgress < 1.0)
                        CircularProgressIndicator(
                          value: uploadProgress,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: provider.titleController,
                decoration: const InputDecoration(
                  labelText: 'Title (50 characters limit)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  if (value.length > 50) {
                    return 'Title should be 50 characters or less';
                  }
                  return null;
                },
                maxLength: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  '${provider.titleController.text.length}/50 characters',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: provider.descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Short Description (20 words limit)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.split(' ').length > 20) {
                    return 'Description should be 20 words or less';
                  }
                  return null;
                },
                maxLines: 3,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  '${provider.descriptionController.text.split(' ').length}/20 words',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(height: 16.0),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {


                   provider.createBlogPost(context);


                  // Perform any additional actions
                },
                child: const Text('Create Blog Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
