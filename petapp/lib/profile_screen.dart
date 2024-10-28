import 'package:flutter/material.dart';
import 'add_profile.dart';
import 'database_helper.dart';

class PetProfileScreen extends StatefulWidget {
  const PetProfileScreen({super.key});

  @override
  ProfileScreen createState() => ProfileScreen();
}

class ProfileScreen extends State<PetProfileScreen> {

  late List<Map<String, dynamic>> _petProfiles = []; // Store pet profiles here
  @override
  void initState() {
    super.initState();
    _loadPetProfiles();
  }
  void _loadPetProfiles() async {
    // Load pet profiles from the database
    final pets = await DatabaseHelper.instance.getPetProfiles();
    setState(() {
      _petProfiles = pets;
    });
  }

  // Method to show a dialog with pet details
  void _showPetDetails(Map<String, dynamic> petProfile) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(petProfile['name']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Species: ${petProfile['species']}'),
              Text('Breed: ${petProfile['breed']}'),
              Text('Age: ${petProfile['age']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
 
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Profiles'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPetProfileScreen(),
                ),
              ).then((_) {
                // Reload the pet profiles when returning from the add screen
                _loadPetProfiles();
              });
            },
          ),
        ],
      ),
      body: Expanded(
        child: ListView.builder(
          itemCount: _petProfiles.length,
          itemBuilder: (context, index) {
            final Map<String, dynamic> pet = _petProfiles[index];
            return Card(
              child: ListTile(
                title: Text(pet['name']),
                subtitle: Text('Species: ${pet['species']}'),
                onTap: () => _showPetDetails(pet),
              ),
            );
          },
        ),
      ),
    );
  }
}