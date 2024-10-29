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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Care Tasks'),
        backgroundColor: const Color.fromARGB(255, 230, 172, 240),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _taskNameController,
              decoration: InputDecoration(
                labelText: 'Add a Task',
                filled: true,
                fillColor: Colors.purple[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _taskTimeController,
              decoration: InputDecoration(
                labelText: 'Task Time (e.g., 8:00 AM)',
                filled: true,
                fillColor: Colors.purple[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 197, 136, 207),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text('Add Task'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  bool isChecked = task['is_completed'] ?? false;

                  return Card(
                    color: isChecked ? Colors.grey[300] : Colors.white, // Gray out the card if checked
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        '${task['task_name']} at ${task['task_time']}',
                        style: TextStyle(
                          color: isChecked ? Colors.grey[600] : Colors.black, // Change text color if checked
                          decoration: isChecked ? TextDecoration.lineThrough : null, // Strikethrough if checked
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          _deleteTask(task['id']);
                        },
                      ),
                      leading: Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            // Simulate checking or unchecking without updating database
                            if (value != null) {
                              task['is_completed'] = value; // Update the local task status
                            }
                          });
                        },
                        activeColor: Colors.green,
                        checkColor: Colors.white,
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
