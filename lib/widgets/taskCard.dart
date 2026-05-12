import 'package:flutter/material.dart';
import '../models/task.dart';

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
