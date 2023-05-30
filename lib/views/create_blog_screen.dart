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

class CreateBlogForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CreateBlogProvider>(context);

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
                  child: provider.selectedImage == null
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
                controller: provider.titleController,
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
              const Spacer(),
              ElevatedButton(
                onPressed: (){
                  provider.createBlogPost(context);
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
