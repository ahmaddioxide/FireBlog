import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireblog/services/auth_services.dart';

class FirestoreServices{
  final blogPostsRef= FirebaseFirestore.instance.collection('blogPosts');
  final usersRef = FirebaseFirestore.instance.collection('users');

  Future<void> setUserData(name, email) async{
    await FirebaseFirestore.instance.collection('users').doc(AuthServices().currentUserUid()).set({
      'name': name,
      'email': email,
    });
  }
  Future<Map<String,dynamic>> getCurrentUser() async{
    try {
      DocumentSnapshot userDataSnapshot=await FirebaseFirestore.instance
          .collection('users').doc(AuthServices().currentUserUid()).get();
      Map<String, dynamic> userData = userDataSnapshot.data() as Map<
          String,
          dynamic>;
      return userData;
    } on Exception catch (e) {
      print(e);
      return {};
    }
  }
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserFromAuthorId(String authorId)async{
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(authorId)
        .get();

  }
  Future getBlogSnapshot(String blogId)async{

    final blogRef = FirebaseFirestore.instance.collection('blogPosts').doc(blogId);
    final blogSnapshot = await blogRef.get();
    return blogSnapshot;
  }
  currentBlogRef(String blogId){
    return FirebaseFirestore.instance.collection('blogPosts').doc(blogId);
  }

Future<void> uploadSocialMediaLinks( Map<String,dynamic> socialMediaLinks) async {
    return await usersRef.doc(AuthServices().currentUserUid()).update({
      'socialMediaLinks': socialMediaLinks,
    });
  }
}
