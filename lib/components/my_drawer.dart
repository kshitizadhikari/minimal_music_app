import 'package:flutter/material.dart';
import 'package:minimal_music_app/screens/settings_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          //logo
          DrawerHeader(
            child: Center(
              child: Icon(Icons.music_note_outlined,
              size: 50,
              color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),

          const SizedBox(height: 100),

          //home tile
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 70),
            child: ListTile(
              title: const Text("H O M E"),
              leading: const Icon(Icons.home),
              onTap: () => Navigator.pop(context),
            ),
          ),

          //settings tile
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 70),
            child: ListTile(
              title: const Text("S E T T I N G S"),
              leading: const Icon(Icons.settings),
              onTap: () {
                //pop drawer
                Navigator.pop(context);

                //go to settings page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
