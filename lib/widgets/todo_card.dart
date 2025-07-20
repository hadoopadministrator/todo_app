import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/screens/todo_details_screen.dart';

class ToDoCard extends StatelessWidget {
  const ToDoCard({
    super.key,
    this.onTapCheck,
    required this.toDoModel,
    required this.onTapDelete,
    this.onTapEdit,
  });
  final Function()? onTapCheck;
  final ToDoModel toDoModel;
  final VoidCallback? onTapDelete;
  final VoidCallback? onTapEdit;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      color: toDoModel.todoItemColor,
      margin: EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: onTapCheck,
              child: Icon(
                toDoModel.isChecked
                    ? Icons.check_box_outlined
                    : Icons.check_box_outline_blank,
                color: toDoModel.isChecked ? Colors.green : Colors.black,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TodoDetailsScreen(toDoModel: toDoModel),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      toDoModel.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      toDoModel.description,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Created Date: ${DateFormat('dd MMM yyyy, hh:mm a').format(toDoModel.createdDate)}",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                InkWell(
                  onTap: onTapDelete,
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.black,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: onTapEdit,
                  child: Icon(Icons.edit_note, color: Colors.black, size: 32),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
