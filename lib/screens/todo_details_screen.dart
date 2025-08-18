import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/widgets/custom_scaffold.dart';

class TodoDetailsScreen extends StatelessWidget {
  final ToDoModel toDoModel;
  const TodoDetailsScreen({super.key, required this.toDoModel});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      automaticallyImplyLeading: true,
      title: "ToDo Details",
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: toDoModel.isChecked ? Colors.grey.shade300 : Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Title: ${toDoModel.title}",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: toDoModel.isChecked ? Colors.grey : Colors.black,
                    decoration: toDoModel.isChecked
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: Colors.black,
                    decorationThickness: 2,
                  ),
                  maxLines: 3,
                ),
              ),
            ),
            Card(
              color: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Description: ${toDoModel.description}",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  'Created: ${DateFormat('dd MMM yyyy, hh:mm a').format(toDoModel.createdDate)}',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            if (toDoModel.isChecked && toDoModel.updatedDate != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.update, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    'Updated: ${DateFormat('dd MMM yyyy, hh:mm a').format(toDoModel.updatedDate!)}',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
