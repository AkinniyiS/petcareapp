
import 'package:flutter/material.dart';
import 'database_helper.dart'; 
import 'main.dart';             

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Care Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');  // Placeholder for settings route
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
                Navigator.pushNamed(context, '/petProfiles');
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
