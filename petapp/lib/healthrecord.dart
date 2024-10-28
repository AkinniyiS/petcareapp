import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import your database helper
import 'addhealthrecord.dart'; // Import the screen to add health records

class HealthRecordsScreen extends StatefulWidget {
  @override
  _HealthRecordsScreenState createState() => _HealthRecordsScreenState();
}

class _HealthRecordsScreenState extends State<HealthRecordsScreen> {
  List<Map<String, dynamic>> _pets = [];
  int? _selectedPetId; // Store the selected pet ID
  List<Map<String, dynamic>> _healthRecords = [];
  String? _selectedPetName; // Store the selected pet name

  @override
  void initState() {
    super.initState();
    _loadPets(); // Load pets on initialization
  }

  void _loadPets() async {
    final pets = await DatabaseHelper.instance.queryAllPetProfiles(); // Load all pet profiles
    setState(() {
      _pets = pets;
    });
  }

  void _loadHealthRecords() async {
    if (_selectedPetId != null) {
      final records = await DatabaseHelper.instance.queryHealthRecords(_selectedPetId!);
      setState(() {
        _healthRecords = records;
        // Update the selected pet name based on the selected ID
        _selectedPetName = _pets.firstWhere((pet) => pet['id'] == _selectedPetId)['name'];
      });
    }
  }

  void _navigateToAddRecord() async {
    if (_selectedPetId != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddHealthRecordScreen(petId: _selectedPetId!),
        ),
      );

      // Reload health records after adding a new record
      _loadHealthRecords();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Records'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<int>(
              hint: Text('Select a pet'),
              value: _selectedPetId,
              onChanged: (int? newPetId) {
                setState(() {
                  _selectedPetId = newPetId; // Store the selected pet ID
                  _loadHealthRecords(); // Load health records for the selected pet
                });
              },
              items: _pets.map((pet) {
                return DropdownMenuItem<int>(
                  value: pet['id'], // Set the ID as the value
                  child: Text(pet['name']),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            if (_selectedPetId != null && _selectedPetName != null) // Show pet info only if a pet is selected
              Text(
                'Health Records for: $_selectedPetName', // Show the pet's name instead of ID
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 20),
            if (_selectedPetId != null) // Show the button only if a pet is selected
              ElevatedButton(
                onPressed: _navigateToAddRecord,
                child: Text('Add Health Record'),
              ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _healthRecords.length,
                itemBuilder: (context, index) {
                  final record = _healthRecords[index];
                  return Card(
                    child: ListTile(
                      title: Text('Vaccination Date: ${record['vaccination_date']}'),
                      subtitle: Text('Details: ${record['record_details']}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
