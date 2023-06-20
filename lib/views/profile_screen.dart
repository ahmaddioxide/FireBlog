import 'package:fireblog/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fireblog/controllers/logout_controller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LogoutController logoutController = Provider.of<LogoutController>(context);

    User? currentUser = FirebaseAuth.instance.currentUser;
    String uid = currentUser?.uid ?? '';

    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SpinKitWave(
              color: Colors.brown,
              size: 50.0,
            );
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Text('No data found');
          }

          Map<String, dynamic> userData =
              snapshot.data!.data() as Map<String, dynamic>;

          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),
                const Text(
                  'Name:',
                  style: TextStyle(
                    color: Colors.brown,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userData['name'] ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Email:',
                  style: TextStyle(
                    color: Colors.brown,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userData['email'] ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Blogs Published:',
                  style: TextStyle(
                    color: Colors.brown,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  // userData['blogsPublished'].toString() ?? "0",
                  userData['blogsPublished']?.toString() ?? '0',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'LinkedIn Profile:',
                  style: TextStyle(
                    color: Colors.brown,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userData['linkedin'] ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Facebook Profile:',
                  style: TextStyle(
                    color: Colors.brown,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userData['facebook'] ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Instagram Profile:',
                  style: TextStyle(
                    color: Colors.brown,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userData['instagram'] ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Twitter Profile:',
                  style: TextStyle(
                    color: Colors.brown,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userData['twitterProfile'] ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      logoutController.logout().then((value) {
                        Navigator.of(context).pushReplacementNamed('/login');
                      }).onError((error, stackTrace) {
                        showSnackBar(context, 'Error Logging Out', Colors.red);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 12.0,
                      ),
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
