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
 void _showPetDetails(Map<String, dynamic> pet) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AddPetProfileScreen(pet: pet), // Pass pet data
    ),
  ).then((shouldReload) {
    if (shouldReload != null && shouldReload) {
      _loadPetProfiles(); // Reload profiles after updating
    }
  });
}

 Future<void> _deletePetProfile(int petId) async {
    // Show confirmation dialog
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Pet Profile'),
          content: Text('Are you sure you want to delete this pet profile?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    // If user confirmed deletion, proceed to delete
    if (shouldDelete == true) {
      await DatabaseHelper.instance.deletePetProfile(petId);
      _loadPetProfiles(); // Reload the profiles to reflect changes
    }
  }

 
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Profiles'),
        actions: [
          TextButton(
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
            style: TextButton.styleFrom(
            backgroundColor: Colors.grey, // Set background color to black
      
            ),
            child: Text(
              'Add Pet',
              style: TextStyle(color: Colors.white), // Change text color to white for visibility
            ),
          ),
        ],
      ),
       body: ListView.builder(
        itemCount: _petProfiles.length,
        itemBuilder: (context, index) {
          final Map<String, dynamic> pet = _petProfiles[index];
          return Card(
            child: ListTile(
              title: Text(pet['name']),
              subtitle: Text('Species: ${pet['species']}'),
              onTap: () => _showPetDetails(pet),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deletePetProfile(pet['id']),
              ),
            ),
          );
        },
      ),
    );
  }
}