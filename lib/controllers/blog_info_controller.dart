import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BlogInfoProvider extends ChangeNotifier {
  int likeCount = 0;
  bool isLiked = false;

  Future<DocumentSnapshot?> getUser(String? authorId) async {
    if (authorId == null || authorId.isEmpty) {
      return Future.value(null);
    }
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(authorId)
        .get();
    if (userData.exists) {
      return Future.value(userData);
    }
    return Future.value(null);
  }

  Future<void> updateLikeCount(String blogId) async {
    final blogRef =
        FirebaseFirestore.instance.collection('blogPosts').doc(blogId);

    final blogSnapshot = await blogRef.get();
    final currentLikes = blogSnapshot.data()?['likes'] ?? 0;
    final likedBy = blogSnapshot.data()?['likedBy'] ?? [];

    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null && likedBy.contains(currentUser.uid)) {
      likedBy.remove(currentUser.uid);
      await blogRef.update(
        {'likes': currentLikes - 1, 'likedBy': likedBy},
      ).onError(
        (error, stackTrace) {
          debugPrint('Error while updating like count: $error');
        },
      );
      likeCount = currentLikes - 1;
      isLiked = false;
    } else {
      likedBy.add(currentUser?.uid);
      await blogRef.update(
        {'likes': currentLikes + 1, 'likedBy': likedBy},
      ).onError(
        (error, stackTrace) {
          debugPrint('Error while updating like count: $error');
        },
      );
      likeCount = currentLikes + 1;
      isLiked = true;
    }

    notifyListeners();
  }

  Future<void> fetchLikeCount(String blogId) async {
    final blogRef =
        FirebaseFirestore.instance.collection('blogPosts').doc(blogId);

    final blogSnapshot = await blogRef.get();
    final currentLikes = blogSnapshot.data()?['likes'] ?? 0;
    final likedBy = blogSnapshot.data()?['likedBy'] ?? [];

    final currentUser = FirebaseAuth.instance.currentUser;
    isLiked = currentUser != null && likedBy.contains(currentUser.uid);
    likeCount = currentLikes;

    notifyListeners();
  }
}
