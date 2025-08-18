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
    final brightness = ThemeData.estimateBrightnessForColor(
      toDoModel.todoItemColor!,
    );
    final Color textColor = brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
        final Color iconInactiveColor = Colors.grey.shade600;

    return Card(
      elevation: 4,
      color: toDoModel.todoItemColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: ClipRRect(
         borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(4),
                  splashColor: Colors.green.withValues(alpha: 0.2),
                  onTap: onTapCheck,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      toDoModel.isChecked
                          ? Icons.check_box_outlined
                          : Icons.check_box_outline_blank,
                      color: toDoModel.isChecked ? Colors.green : iconInactiveColor,
                      size: 28,
                      semanticLabel: toDoModel.isChecked ? 'Mark as incomplete' : 'Mark as complete',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                   splashColor: Colors.grey.withValues(alpha:0.1),
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
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: textColor,
                          decoration: toDoModel.isChecked
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                       const SizedBox(height: 4), 
                      Text(
                        toDoModel.description,
                        style: TextStyle(fontSize: 14, color: textColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                       const SizedBox(height: 4), 
                      Text(
                        "Created: ${DateFormat('dd MMM yyyy, hh:mm a').format(toDoModel.createdDate)}",
                        style: TextStyle(
                          fontSize: 12,
                          color: textColor.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6),
                      splashColor: Colors.red.withValues(alpha:  0.2),
                      onTap: onTapDelete,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Icon(
                          Icons.delete_outline,
                          color: Colors.black87,
                          size: 28,
                          semanticLabel: 'Delete ToDo item',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6),
                      splashColor: Colors.blue.withValues(alpha:0.2),
                      onTap: onTapEdit,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Icon(
                          Icons.edit_note,
                          color: Colors.blueAccent,
                          size: 28,
                           semanticLabel: 'Edit ToDo item',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
