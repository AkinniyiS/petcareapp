import 'package:flutter/material.dart';
import 'database_helper.dart'; // Make sure to import your database helper

class AddPetProfileScreen extends StatefulWidget {
  @override
  _AddPetProfileScreenState createState() => _AddPetProfileScreenState();
}

class _AddPetProfileScreenState extends State<AddPetProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();

  void _addPetProfile() async {
    if (_formKey.currentState!.validate()) {
      // Create a new pet profile
      await DatabaseHelper.instance.insertPetProfile({
        'name': _nameController.text,
        'species': _speciesController.text,
        'breed': _breedController.text,
        'age': int.tryParse(_ageController.text),
      });

      // Go back to the previous screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Pet Profile'),
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
                onPressed: _addPetProfile,
                child: Text('Add Pet Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}