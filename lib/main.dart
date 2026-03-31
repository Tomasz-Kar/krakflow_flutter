import 'package:flutter/material.dart';
import 'task_repository.dart';

void main() {
  runApp(MyApp());
}

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({super.key});
  final TextEditingController titleController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nowe zadanie"),
      ),
      body: Padding(padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [TextField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: "Tytul zadania",
            border: OutlineInputBorder(),
          ),
        ),
        TextField(
            controller: deadlineController,
            decoration: InputDecoration(
              labelText: "termin zadania",
              border: OutlineInputBorder(),
            ),
        ),
          TextField(
            controller: priorityController,
            decoration: InputDecoration(
              labelText: "priorytet zadania",
              border: OutlineInputBorder(),
            ),
          ),
        ElevatedButton(onPressed: () {
          final newTask = Task(title: titleController.text, deadline: deadlineController.text, priority: priorityController.text, done: false);
          Navigator.pop(context,newTask);
        }, child: Text("Zapisz"))
        ],
      )
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    List<Task> tasks = TaskRepository.tasks;
    return Scaffold(
      appBar: AppBar(
        title: Text("KrakFlow"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "Masz dzisiaj ${tasks.length} zadania\nDzisiejsze zadania:\n",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 15, horizontal: 35),
                child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      if (tasks[index].done) {
                        return TaskCard(
                          title: tasks[index].title,
                          subtitle: "termin: ${tasks[index]
                              .deadline} | priorytet: ${tasks[index]
                              .priority}",
                          icon: Icons.radio_button_checked,
                        );
                      }
                      return Column(
                          children: [TaskCard(
                            title: tasks[index].title,
                            subtitle: "termin: ${tasks[index]
                                .deadline} | priorytet: ${tasks[index]
                                .priority}",
                            icon: Icons.radio_button_unchecked,
                          ), SizedBox(height: 10)]);
                    }
                ),
              ),
            ),
          ],
        ),
      ), floatingActionButton: FloatingActionButton(onPressed: () async {final Task? newTask = await Navigator.push(context,
        PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => AddTaskScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child:child);
          }
        ));
        if (newTask != null) {
          setState(() {
            TaskRepository.tasks.add(newTask);
          });
        }
        }, child: Icon(Icons.add),)
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen()
    );
  }
}

  class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const TaskCard({
  super.key,
  required this.title,
  required this.subtitle,
  required this.icon,
  });

  @override
  Widget build(BuildContext context) {
  return Card(
  child: ListTile(
  leading: Icon(icon),
  title: Text(title),
  subtitle: Text(subtitle),
  ),
  );
  }
  }
