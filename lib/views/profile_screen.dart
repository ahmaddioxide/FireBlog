import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller..dart';
import '../controllers/user_data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserData userData = Provider.of<UserData>(context);

    return Scaffold(

      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CircleAvatar(
            //   radius: 60,
            //   backgroundImage: NetworkImage(userData.profileImageUrl), // Assuming there's a profile image URL in the UserData
            // ),
            // const SizedBox(height: 16.0),
            Text(
              'Name:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              userData.name,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Email:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              userData.email,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                AuthController authController = Provider.of<AuthController>(context, listen: false);
                authController.logout(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // Set the button's background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
