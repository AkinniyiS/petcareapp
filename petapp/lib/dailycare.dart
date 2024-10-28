import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import your database helper

class DailyCareTaskScreen extends StatefulWidget {
  @override
  _DailyCareTaskScreenState createState() => _DailyCareTaskScreenState();
}

class _DailyCareTaskScreenState extends State<DailyCareTaskScreen> {
  final _taskNameController = TextEditingController();
  final _taskTimeController = TextEditingController();
  List<Map<String, dynamic>> _tasks = [];
  
  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    final tasks = await DatabaseHelper.instance.queryDailyCareTasks(1); // Example pet ID
    setState(() {
      _tasks = tasks;
    });
  }

  void _addTask() async {
    final taskName = _taskNameController.text;
    final taskTime = _taskTimeController.text;
    
    if (taskName.isNotEmpty && taskTime.isNotEmpty) {
      await DatabaseHelper.instance.insertDailyCareTask({
        'task_name': taskName,
        'task_time': taskTime, // Make sure to include task_time
        'pet_id': 1, // Example pet ID
      });
      _taskNameController.clear();
      _taskTimeController.clear();
      _loadTasks();
    }
  }

  void _deleteTask(int id) async {
    await DatabaseHelper.instance.deleteDailyCareTask(id);
    _loadTasks();
  }

  void _toggleTaskCompletion(int id, bool isChecked) async {
    // Optionally update the task completion status
    // This requires updating the database schema to include a completion status
    // You can define a new column `is_completed` in the daily care tasks table
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Care Tasks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskNameController,
              decoration: InputDecoration(labelText: 'Add a Task'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _taskTimeController,
              decoration: InputDecoration(labelText: 'Task Time (e.g., 8:00 AM)'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addTask,
              child: Text('Add Task'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return Card(
                    child: ListTile(
                      title: Text(task['task_name']+ " "+task['task_time']),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteTask(task['id']);
                        },
                      ),
                      leading: Checkbox(
                        value: task['is_completed'] ?? false,
                        onChanged: (value) {
                          setState(() {
                            _toggleTaskCompletion(task['id'], value!);
                          });
                        },
                        activeColor: Colors.green, 
                        checkColor: Colors.green,
                      ),
                    )
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