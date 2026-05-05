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
      appBar: AppBar(title: Text("Nowe zadanie")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 15,
          children: [
            TextField(
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
            ElevatedButton(
              onPressed: () {
                final newTask = Task(
                  title: titleController.text,
                  deadline: deadlineController.text,
                  priority: priorityController.text,
                  done: false,
                );
                Navigator.pop(context, newTask);
              },
              child: Text("Zapisz"),
            ),
          ],
        ),
      ),
    );
  }
}

class EditTaskScreen extends StatelessWidget {
  EditTaskScreen({super.key, required this.initialTask});

  final Task initialTask;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = initialTask.title;
    deadlineController.text = initialTask.deadline;
    priorityController.text = initialTask.priority;
    return Scaffold(
      appBar: AppBar(title: Text("Edycja zadania")),
      body: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 15,
          children: [
            TextField(
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
            ElevatedButton(
              onPressed: () {
                final newTask = Task(
                  title: titleController.text,
                  deadline: deadlineController.text,
                  priority: priorityController.text,
                  done: false,
                );
                Navigator.pop(context, newTask);
              },
              child: Text("Zapisz"),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class FilterBar extends StatelessWidget {
  static final selectedStyle = TextButton.styleFrom(
    backgroundColor: Colors.green,
    foregroundColor: Colors.white,
  );
  final void Function(String) changeFilter;
  final String selectedFilter;

  const FilterBar({
    super.key,
    required this.changeFilter,
    required this.selectedFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () => changeFilter("wszystkie"),
          child: Text("Wszystkie"),
          style: selectedFilter == "wszystkie" ? selectedStyle : null,
        ),
        TextButton(
          onPressed: () => changeFilter("wykonane"),
          child: Text("Wykonane"),
          style: selectedFilter == "wykonane" ? selectedStyle : null,
        ),
        TextButton(
          onPressed: () => changeFilter("do zrobienia"),
          child: Text("Do Zrobienia"),
          style: selectedFilter == "do zrobienia" ? selectedStyle : null,
        ),
      ],
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  String filter = "wszystkie";
  String selectedFilter = "wszystkie";

  void changeFilter(String newFilter) {
    setState(() {
      selectedFilter = newFilter;
    });
  }

  AlertDialog deleteAllTasksDialog() {
    return AlertDialog(
      title: Text("Potwierdzenie"),
      content: Text("Czy na pewno chcesz usunąć wszystkie zadania?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Anuluj"),
        ),
        TextButton(
          onPressed: () =>
              setState(() {
                TaskRepository.tasks.clear();
                Navigator.pop(context);
              }),
          child: Text("Usuń"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(   //Ma cache'owac wynik czy za kazdym razem pobierac z serwera? Narazie zakladam to drugie.
      future: TaskApiService.fetchTasks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Scaffold(body:Center(child: Text("Błąd: ${snapshot.error}")));
        }
        TaskRepository.tasks = snapshot.data!;
        List<Task> filteredTasks = TaskRepository.tasks;

    if (selectedFilter == "wykonane") {
      filteredTasks = TaskRepository.tasks.where((task) => task.done).toList();
    } else if (selectedFilter == "do zrobienia") {
      filteredTasks = TaskRepository.tasks.where((task) => !task.done).toList();
    }
    return Scaffold(
      appBar: TaskRepository.tasks.isNotEmpty
          ? AppBar(
        title: Text("KrakFlow"),
        actions: [
          IconButton(
            onPressed: () =>
                showDialog(
                  context: context,
                  builder: (context) {
                    return deleteAllTasksDialog();
                  },
                ),
            icon: Icon(Icons.delete),
          ),
        ],
      )
          : AppBar(
        title: Text("KrakFlow"),
        actions: [
          IconButton(
            onPressed: () =>
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Nie ma zadań do usunięcia!"),
                  ),
                ),
            icon: Icon(Icons.delete),
            style: TextButton.styleFrom(foregroundColor: Colors.grey),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text("Masz dzisiaj ${TaskRepository.tasks.length} zadania\nDzisiejsze zadania:\n",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            FilterBar(changeFilter: changeFilter, selectedFilter: selectedFilter),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                child: ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    return Dismissible(
                      direction: DismissDirection.startToEnd,
                      key: ValueKey(task.title),
                      onDismissed: (direction) {
                        setState(() {
                          TaskRepository.tasks.remove(task);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Zadanie \"${task.title}\" usunięte.",
                            ),
                          ),
                        );
                      },
                      child: TaskCard(
                        task: task,
                        onChanged: (value) {
                          setState(() {
                            task.done = value!;
                          });
                        },
                        onTap: () async {
                          final Task? updatedTask = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditTaskScreen(initialTask: task),
                            ),
                          );
                          if (updatedTask != null) {
                            setState(() {
                              TaskRepository.tasks[index] = updatedTask;
                            });
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Task? newTask = await Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  AddTaskScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          );
          if (newTask != null) {
            setState(() {
              TaskRepository.tasks.add(newTask);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
    );}
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}

class TaskCard extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?>? onChanged;
  final VoidCallback? onTap;

  const TaskCard({super.key, required this.task, this.onChanged, this.onTap});

  @override
  Widget build(BuildContext context) {
    Color textColor = task.done
        ? Color.fromRGBO(125, 125, 125, 1)
        : Color.fromRGBO(0, 0, 0, 1);
    Color highlightColor = task.done
        ? Color.fromRGBO(250, 200, 200, 1)
        : Color.fromRGBO(240, 10, 10, 1);
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(value: task.done, onChanged: onChanged),
        title: Text(
          task.title,
          style: TextStyle(
            color: textColor,
            decoration: task.done
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(
              context,
            ).style.copyWith(color: textColor),
            children: [
              TextSpan(text: "termin: ${task.deadline} | "),
              TextSpan(
                text: "priorytet: ${task.priority}",
                style: TextStyle(color: highlightColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
