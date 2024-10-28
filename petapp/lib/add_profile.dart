import 'package:flutter/material.dart';
import 'database_helper.dart'; // Make sure to import your database helper

class AddPetProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? pet; // Accepting pet data for updates

  const AddPetProfileScreen({Key? key, this.pet}) : super(key: key);

  @override
  _AddPetProfileScreenState createState() => _AddPetProfileScreenState();
}

class _AddPetProfileScreenState extends State<AddPetProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.pet != null) {
      // If pet data is provided, populate the fields
      _nameController.text = widget.pet!['name'];
      _speciesController.text = widget.pet!['species'];
      _breedController.text = widget.pet!['breed'] ?? ''; // Handle potential null
      _ageController.text = widget.pet!['age']?.toString() ?? ''; // Handle potential null
    }
  }

  void _addOrUpdatePetProfile() async {
    if (_formKey.currentState!.validate()) {
      final petProfile = {
        'name': _nameController.text,
        'species': _speciesController.text,
        'breed': _breedController.text,
        'age': int.tryParse(_ageController.text),
      };

      if (widget.pet == null) {
        // Insert new pet profile
        await DatabaseHelper.instance.insertPetProfile(petProfile);
      } else {
        // Update existing pet profile
        petProfile['id'] = widget.pet!['id']; // Add ID for updating
        await DatabaseHelper.instance.updatePetProfile(petProfile);
      }

      // Go back to the previous screen
      Navigator.pop(context, true); // Return true to indicate an update
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet == null ? 'Add Pet Profile' : 'Edit Pet Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the pet\'s name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _speciesController,
                decoration: InputDecoration(labelText: 'Species'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the species';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _breedController,
                decoration: InputDecoration(labelText: 'Breed'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the breed';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the age';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addOrUpdatePetProfile,
                child: Text(widget.pet == null ? 'Add Pet Profile' : 'Update Pet Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}