class Task {
  final String title;
  final String deadline;
  final String priority;
  final bool done;

  Task({required this.title, required this.deadline, required this.priority, required this.done});
}


class TaskRepository {
  static List<Task> tasks = [
    Task(title: "Projekt metodologia",
        deadline: "nastepna sroda",
        priority: "niski",
        done: true),
    Task(title: "Cwiczenia z analizy",
        deadline: "za 2 tygodnie",
        priority: "niski",
        done: false),
    Task(title: "Zadanie z systemow",
        deadline: "w tym miesiacu",
        priority: "sredni",
        done: false),
    Task(title: "Dokonczyc laboratorium",
        deadline: "jutro",
        priority: "wysoki",
        done: true),
  ];
}