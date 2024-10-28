
import 'package:flutter/material.dart';
import 'profile_screen.dart';         
import "settings.dart";

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Care Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              ); 
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Pet Care!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.pets),
              label: Text('Manage Pet Profiles'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PetProfileScreen()),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.health_and_safety),
              label: Text('View Health Records'),
              onPressed: () {
                Navigator.pushNamed(context, '/healthRecords');
              },
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.task),
              label: Text('Daily Care Tasks'),
              onPressed: () {
                Navigator.pushNamed(context, '/dailyCareTasks');
              },
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                child: Text('Logout'),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login'); // Go back to login
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
