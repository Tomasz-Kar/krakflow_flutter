import 'package:flutter/material.dart';
import 'package:krakflow_flutter/services/notification_service.dart';
import '../models/task.dart';
import 'filterBar.dart';
import 'edit_task_screen.dart';
import 'add_task_screen.dart';
import 'taskCard.dart';
import '../services/task_sync_service.dart';
import '../services/task_local_database.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String selectedFilter = "wszystkie";
  late Future<List<Task>> tasksFuture;

  @override
  void initState() {
    super.initState();
    tasksFuture = loadTasks();
  }

  Future<List<Task>> loadEmptyTasks() async {  //Tylko po pelnym wyczyszczeniu
    return TaskLocalDatabase.getTasks();
  }

  Future<List<Task>> loadTasks() async {
    await TaskSyncService.loadInitialDataIfNeeded();
    return TaskLocalDatabase.getTasks();
  }

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
          onPressed: () async {
          await TaskLocalDatabase.deleteAllTasks();
              setState(() {
                Navigator.pop(context);
                tasksFuture = loadEmptyTasks();
              });},
          child: Text("Usuń"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
        future: tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasError) {
            return Scaffold(body:Center(child: Text("Błąd: ${snapshot.error}")));
          }
          final tasks = snapshot.data ?? [];
          List<Task> filteredTasks = tasks;

          if (selectedFilter == "wykonane") {
            filteredTasks = tasks.where((task) => task.done).toList();
          } else if (selectedFilter == "do zrobienia") {
            filteredTasks = tasks.where((task) => !task.done).toList();
          }
          return Scaffold(
            appBar: tasks.isNotEmpty
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
                  Text("Masz dzisiaj ${tasks.length} zadania\nDzisiejsze zadania:\n",
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
                            onDismissed: (direction) async {
                              await TaskLocalDatabase.deleteTask(task.id);
                              setState(() {
                                tasksFuture = loadTasks();    //Nie sprawdzam czy lista zadan jest pusta, jezeli usune ostatnie zadanie to lista od nowa sie pobiera.
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
                              onChanged: (value) async {
                                final isDone = value ?? false;
                                final wasDone = task.done;

                                final updatedTask = Task(
                                  id: task.id,
                                  title: task.title,
                                  deadline: task.deadline,
                                  priority: task.priority,
                                  done: value ?? false,
                                );
                                await TaskLocalDatabase.updateTask(updatedTask);
                                setState(() {
                                  tasksFuture = loadTasks();
                                });
                                if(!wasDone && isDone) {
                                  await NotificationService.showTaskDoneNotification(task.title);
                                }
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
                                  await TaskLocalDatabase.updateTask(updatedTask);
                                  setState(() {
                                    tasksFuture = loadTasks();
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
                  TaskLocalDatabase.addTask(newTask);
                  setState(() {
                    tasksFuture = loadTasks();
                  });
                }
              },
              child: Icon(Icons.add),
            ),
          );
        }
    );}
}
