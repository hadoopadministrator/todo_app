import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/screens/login_screen.dart';
import 'package:todo/services/database_service.dart';
import 'package:todo/widgets/color_ontainer.dart';
import 'package:todo/widgets/custom_scaffold.dart';
import 'package:todo/widgets/custom_text_form_field.dart';
import 'package:todo/widgets/todo_card.dart';

class TodoHomeScreen extends StatefulWidget {
  final String name;
  const TodoHomeScreen({super.key, required this.name});

  @override
  State<TodoHomeScreen> createState() => _TodoHomeScreenState();
}

class _TodoHomeScreenState extends State<TodoHomeScreen> {
  final StreamController<List<ToDoModel>> _todoStreamController =
      StreamController.broadcast();
  List<ToDoModel> toDoModel = [];

  bool _areAllSelected = false;
  final ScrollController _scrollController = ScrollController();
  bool _isFabVisible = true;

  Future<void> _loadTodosFromDataBase() async {
    final todos = await DatabaseService.instance.getAllToDos();
    toDoModel = todos;
    _todoStreamController.add(todos);
    _areAllSelected = toDoModel.isNotEmpty && toDoModel.every((todo) => todo.isChecked);
    debugPrint("toDoModel loaded: ${toDoModel.length}");
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _bottomSheetPop() {
    Navigator.pop(context);
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLogin');
    await prefs.remove('name');
    _navigateToLogin();
  }

  @override
  void initState() {
    super.initState();
    _loadTodosFromDataBase();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isFabVisible) {
          setState(() => _isFabVisible = false);
        }
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isFabVisible) {
          setState(() => _isFabVisible = true);
        }
      }
    });
  }

  @override
  void dispose() {
    _todoStreamController.close();
    _scrollController.dispose();
    DatabaseService.instance.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      actions: [
        IconButton(
          onPressed: () async {
            bool allChecked = toDoModel.every((todo) => todo.isChecked);
            for (var todo in toDoModel) {
              todo.isChecked = !allChecked;
              todo.updatedDate = todo.isChecked ? DateTime.now() : null;
              await DatabaseService.instance.updateToDo(todo);
            }
            _areAllSelected = !allChecked;
            _loadTodosFromDataBase();
            setState(() {});
          },
          icon: Icon(
            _areAllSelected
                ? Icons.check_box_outlined
                : Icons.check_box_outline_blank,
            color: _areAllSelected ? Colors.green : Colors.black,
            size: 28,
          ),
        ),

        IconButton(
          onPressed: () async {
            _logout();
          },
          icon: Icon(Icons.logout_outlined, color: Colors.black, size: 32),
        ),
      ],
      title: 'Hi ${widget.name}, ToDo App',
      floatingActionButton: AnimatedSlide(
        offset: _isFabVisible ? Offset.zero : Offset(0, 2),
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        child: FloatingActionButton(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          elevation: 10,
          onPressed: () {
            _showBottomSheet(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
      child: StreamBuilder<List<ToDoModel>>(
        stream: _todoStreamController.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                color: Colors.green,
              ),
            );
          }
          final todos = snapshot.data!;
          if (todos.isEmpty) {
            return Center(
              child: Text(
                'Welcome ${widget.name} to ToDo!\n\nNo tasks added yet!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }
          return ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.only(bottom: 80),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              return ToDoCard(
                onTapCheck: () async {
                  final currentTodo = todos[index];
                  currentTodo.isChecked = !currentTodo.isChecked;
                  currentTodo.updatedDate = currentTodo.isChecked
                      ? DateTime.now()
                      : null;
                  await DatabaseService.instance.updateToDo(currentTodo);
                  _loadTodosFromDataBase();
                  _areAllSelected = todos.isNotEmpty && todos.every((todo) => todo.isChecked);
                  setState(() {});
                  debugPrint('currentTodo Todo: ${currentTodo.toJson()}');
                },
                toDoModel: todos[index],
                onTapDelete: () async {
                  final int deletedId = todos[index].id!;
                  debugPrint('deletedTodo Todo: ${todos[index].toJson()}');
                  await DatabaseService.instance.deleteToDo(deletedId);
                  _loadTodosFromDataBase();
                  debugPrint('deletedId Todo: $deletedId');
                },
                onTapEdit: () {
                  _showBottomSheet(
                    context,
                    isEdit: true,
                    toDoItem: todos[index],
                    position: index,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<dynamic> _showBottomSheet(
    BuildContext context, {
    bool isEdit = false,
    ToDoModel? toDoItem,
    int? position,
  }) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    const List<Color> colors = [
      Color(0xFFFF8A80),
      Color(0xFFFFD740),
      Color(0xFFB9F6CA),
      Color(0xFFEEEEEE),
    ];
    Color? selectedColor = colors[3];
    if (isEdit && toDoItem != null) {
      titleController.text = toDoItem.title;
      descriptionController.text = toDoItem.description;
      selectedColor = toDoItem.todoItemColor;
    }

    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      backgroundColor: Colors.white,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            right: 16,
            top: 16,
            left: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 40,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                Text(
                  isEdit ? "Edit Task" : "Add Task",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  maxLines: 1,
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  labelText: 'Title',
                  controller: titleController,
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  labelText: 'Description',
                  controller: descriptionController,
                  maxLines: 2,
                ),
                const SizedBox(height: 20),

                StatefulBuilder(
                  builder: (context, colorState) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: colors
                        .map(
                          (color) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ColorContainer(
                              color: color,
                              onTapColor: () {
                                colorState(() {
                                  selectedColor = color;
                                });
                              },
                              border: selectedColor == color
                                  ? Border.all(
                                      width: 2.5,
                                      color: Colors.black87,
                                    )
                                  : Border.all(style: BorderStyle.none),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),

                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Icon(
                    isEdit ? Icons.edit_note : Icons.add_task,
                    size: 35,
                  ),
                  onPressed: () async {
                    final title = titleController.text.trim();
                    final description = descriptionController.text.trim();
                    if (title.isNotEmpty && description.isNotEmpty) {
                      if (isEdit && position != null) {
                        final existing = toDoModel[position];
                        existing.title = title;
                        existing.description = description;
                        existing.todoItemColor = selectedColor;
                        existing.updatedDate = DateTime.now();
                        await DatabaseService.instance.updateToDo(existing);
                        _loadTodosFromDataBase();
                        debugPrint('Updated Todo: ${existing.toJson()}');
                      } else {
                        final newTodo = ToDoModel(
                          isChecked: false,
                          title: title,
                          description: description,
                          createdDate: DateTime.now(),
                          todoItemColor: selectedColor,
                        );
                        final int id = await DatabaseService.instance
                            .insertToDo(newTodo);
                        newTodo.id = id;
                        _loadTodosFromDataBase();
                        _areAllSelected =
                            toDoModel.isNotEmpty &&
                            toDoModel.every((todo) => todo.isChecked);
                        debugPrint('Added Todo: ${newTodo.toJson()}');
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Title and description can't be empty"),
                        ),
                      );
                    }

                    _bottomSheetPop();
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
