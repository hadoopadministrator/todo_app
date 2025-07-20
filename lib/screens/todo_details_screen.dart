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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title: ${toDoModel.title}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                decoration: toDoModel.isChecked
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                decorationColor: Colors.black,
                decorationThickness: 2,
              ),
              maxLines: 2,
            ),

            const SizedBox(height: 10),
            Text(
              "Description: ${toDoModel.description}",

              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Created Date: ${DateFormat('dd MMM yyyy, hh:mm a').format(toDoModel.createdDate)}',
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
            ),
            if (toDoModel.isChecked) ...{
              const SizedBox(height: 10),
              Text(
                'Updated Date: ${DateFormat('dd MMM yyyy, hh:mm a').format(toDoModel.updatedDate!)}',
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
              ),
            },
          ],
        ),
      ),
    );
  }
}
