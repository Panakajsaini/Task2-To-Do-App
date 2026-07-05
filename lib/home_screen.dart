import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _tasks = [];

  void _loadTasks() async {
    final data = await DBHelper.getTasks();
    setState(() {
      _tasks = data;
    });
  }

  void _addTask(String title, String description) async {
    await DBHelper.insertTask(title, description);
    _loadTasks();
  }

  void _deleteTask(int id) async {
    await DBHelper.deleteTask(id);
    _loadTasks();
  }

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("My To-Do List"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (ctx, i) => ListTile(
          title: Text(_tasks[i]['title']),
          subtitle: Text(_tasks[i]['description']),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deleteTask(_tasks[i]['id']),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("Add Task"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: titleController, decoration: InputDecoration(labelText: "Title")),
                  TextField(controller: descController, decoration: InputDecoration(labelText: "Description")),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _addTask(titleController.text, descController.text);
                    Navigator.pop(context);
                  },
                  child: Text("Save"),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
