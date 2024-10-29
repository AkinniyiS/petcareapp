import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'addhealthrecord.dart';

class HealthRecordsScreen extends StatefulWidget {
  @override
  _HealthRecordsScreenState createState() => _HealthRecordsScreenState();
}

class _HealthRecordsScreenState extends State<HealthRecordsScreen> {
  List<Map<String, dynamic>> _pets = [];
  int? _selectedPetId;
  List<Map<String, dynamic>> _healthRecords = [];
  String? _selectedPetName;

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  void _loadPets() async {
    final pets = await DatabaseHelper.instance.queryAllPetProfiles();
    setState(() {
      _pets = pets;
    });
  }

  void _loadHealthRecords() async {
    if (_selectedPetId != null) {
      final records = await DatabaseHelper.instance.queryHealthRecords(_selectedPetId!);
      setState(() {
        _healthRecords = records;
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
      _loadHealthRecords();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Records'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Select a pet',
                labelStyle: TextStyle(color: Colors.redAccent),
                filled: true,
                fillColor: Colors.red[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              value: _selectedPetId,
              onChanged: (int? newPetId) {
                setState(() {
                  _selectedPetId = newPetId;
                  _loadHealthRecords();
                });
              },
              items: _pets.map((pet) {
                return DropdownMenuItem<int>(
                  value: pet['id'],
                  child: Text(pet['name']),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            if (_selectedPetId != null && _selectedPetName != null)
              Text(
                'Health Records for: $_selectedPetName',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            SizedBox(height: 20),
            if (_selectedPetId != null)
              Center(
                child: ElevatedButton(
                  onPressed: _navigateToAddRecord,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text('Add Health Record'),
                ),
              ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _healthRecords.length,
                itemBuilder: (context, index) {
                  final record = _healthRecords[index];
                  return Card(
                    color: Colors.red[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        'Vaccination Date: ${record['vaccination_date']}',
                        style: TextStyle(color: Colors.redAccent[700]),
                      ),
                      subtitle: Text(
                        'Details: ${record['record_details']}',
                        style: TextStyle(color: Colors.redAccent[300]),
                      ),
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
