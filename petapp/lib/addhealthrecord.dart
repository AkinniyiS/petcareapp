import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import your database helper

class AddHealthRecordScreen extends StatefulWidget {
  final int petId;

  AddHealthRecordScreen({required this.petId});

  @override
  _AddHealthRecordScreenState createState() => _AddHealthRecordScreenState();
}

class _AddHealthRecordScreenState extends State<AddHealthRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vaccinationDateController = TextEditingController();
  final _recordDetailsController = TextEditingController();

  void _addHealthRecord() async {
    if (_formKey.currentState!.validate()) {
      await DatabaseHelper.instance.insertHealthRecord({
        'vaccination_date': _vaccinationDateController.text,
        'record_details': _recordDetailsController.text,
        'pet_id': widget.petId,
      });

      Navigator.pop(context); // Go back to the health records screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Health Record'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _vaccinationDateController,
                decoration: InputDecoration(labelText: 'Vaccination Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the vaccination date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _recordDetailsController,
                decoration: InputDecoration(labelText: 'Record Details'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the record details';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addHealthRecord,
                child: Text('Add Record'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
