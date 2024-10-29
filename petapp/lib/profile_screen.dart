import 'package:flutter/material.dart';
import 'add_profile.dart';
import 'database_helper.dart';

class PetProfileScreen extends StatefulWidget {
  const PetProfileScreen({super.key});

  @override
  ProfileScreen createState() => ProfileScreen();
}

class ProfileScreen extends State<PetProfileScreen> {
  late List<Map<String, dynamic>> _petProfiles = [];

  @override
  void initState() {
    super.initState();
    _loadPetProfiles();
  }

  void _loadPetProfiles() async {
    final pets = await DatabaseHelper.instance.getPetProfiles();
    setState(() {
      _petProfiles = pets;
    });
  }

  void _showPetDetails(Map<String, dynamic> pet) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPetProfileScreen(pet: pet),
      ),
    ).then((shouldReload) {
      if (shouldReload != null && shouldReload) {
        _loadPetProfiles();
      }
    });
  }

  Future<void> _deletePetProfile(int petId) async {
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

    if (shouldDelete == true) {
      await DatabaseHelper.instance.deletePetProfile(petId);
      _loadPetProfiles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Profiles'),
        backgroundColor: const Color.fromARGB(255, 204, 209, 133),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPetProfileScreen(),
                ),
              ).then((_) {
                _loadPetProfiles();
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.blueGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Add Pet',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: _petProfiles.length,
          itemBuilder: (context, index) {
            final Map<String, dynamic> pet = _petProfiles[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                title: Text(
                  pet['name'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[700],
                  ),
                ),
                subtitle: Text(
                  'Species: ${pet['species']}',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blueGrey[600],
                  ),
                ),
                onTap: () => _showPetDetails(pet),
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red[400],
                  ),
                  onPressed: () => _deletePetProfile(pet['id']),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
