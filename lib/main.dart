import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

List<Task> tasks = [
  Task(title: "Projekt metodologia", deadline: "nastepna sroda", priority: "niski", done: true),
  Task(title: "Cwiczenia z analizy", deadline: "za 2 tygodnie", priority: "niski", done: false),
  Task(title: "Zadanie z systemow", deadline: "w tym miesiacu", priority: "sredni", done: false),
  Task(title: "Dokonczyc laboratorium", deadline: "jutro", priority: "wysoki", done: true),
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("KrakFlow")),
        body: Center(
          child: Column(
            children: [
              Text(
                "Masz dzisiaj ${tasks.length} zadania\nDzisiejsze zadania:\n",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return Column(
                          children: [TaskCard(
                        title: tasks[index].title,
                        subtitle: "termin: ${tasks[index].deadline} | priorytet: ${tasks[index].priority}", ////////
                        icon: Icons.star,
                      ), SizedBox(height: 10)]);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Task {
  final String title;
  final String deadline;
  final String priority;
  final bool done;

  Task({required this.title, required this.deadline, required this.priority, required this.done});
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
