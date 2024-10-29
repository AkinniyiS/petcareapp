import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'settings.dart';
import 'dailycare.dart';
import 'healthrecord.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _launchMap() async {
    var url = Uri(
      scheme: 'https',
      host: 'www.google.com',
      path: '/maps/search/',
      queryParameters: {'api': '1', 'query': 'animal+hospital'},
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pet Care Home',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white, size: 30),
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome to Pet Care!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 30),
            _buildButton(
              context,
              icon: Icons.pets,
              label: 'Manage Pet Profiles',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PetProfileScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildButton(
              context,
              icon: Icons.health_and_safety,
              label: 'View Health Records',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HealthRecordsScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildButton(
              context,
              icon: Icons.task,
              label: 'Daily Care Tasks',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DailyCareTaskScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildButton(
              context,
              icon: Icons.local_hospital,
              label: 'Find Nearest Animal Hospital',
              onPressed: _launchMap,
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        backgroundColor: Colors.blue[400],
        foregroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      icon: Icon(icon, size: 40, color: const Color.fromARGB(255, 157, 193, 223)),
      label: Text(label, style: const TextStyle(fontSize: 20)),
      onPressed: onPressed,
    );
  }
}
