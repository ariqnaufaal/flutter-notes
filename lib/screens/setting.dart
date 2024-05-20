import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});


  void logout() {
    FirebaseAuth.instance.signOut();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NotesFolders'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.edit_document),
            title: const Text('All Notes'),
            onTap: () {
              // Implement navigation to notifications settings
            },
          ),
          const Divider(), // Divider after All Notes
          ListTile(
            leading: const Icon(Icons.star_border),
            title: const Text('Favorites'),
            onTap: () {
              // Implement navigation to theme settings
            },
          ),
          const Divider(), // Divider after Favorites
          ListTile(
            leading: const Icon(Icons.list_alt_outlined),
            title: const Text('To do lists'),
            onTap: () {
              // Implement navigation to privacy settings
            },
          ),
          const Divider(), // Divider after To do lists
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Recently Deleted'),
            onTap: () {
              // Implement navigation to about page
            },
          ),
          const Divider(), // Divider after Recently Deleted
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Implement navigation to help and feedback page
            },
          ),
          const Divider(),   
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Implement logout
                // pop drawer
                  Navigator.pop(context);
            
                  // logout
                  logout();
              },
            ),
          ),
        ],
      ),
    );
  }
}
