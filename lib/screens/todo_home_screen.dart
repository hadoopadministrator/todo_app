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
  final ScrollController _scrollController = ScrollController();

  bool _areAllSelected = false;
  // bool _isFabVisible = true;
  final ValueNotifier<bool> _isFabVisible = ValueNotifier(true);


  Future<void> _loadTodosFromDataBase() async {
    try {
      final todos = await DatabaseService.instance.getAllToDos();
      if (!_todoStreamController.isClosed) {
        _todoStreamController.add(todos);
      }
      _updateAreAllSelected(todos);
      debugPrint("toDoModel loaded: ${todos.length}");
    } catch (e) {
      debugPrint('Error loading todos: $e');
    }
  }

  void _updateAreAllSelected(List<ToDoModel> todos) {
    _areAllSelected = todos.isNotEmpty && todos.every((todo) => todo.isChecked);
  }

  Future<void> _onCheckToggle(ToDoModel todo) async {
    todo.isChecked = !todo.isChecked;
    todo.updatedDate = todo.isChecked ? DateTime.now() : null;
    await DatabaseService.instance.updateToDo(todo);
    await _loadTodosFromDataBase();
    debugPrint('currentTodo Todo: ${todo.toJson()}');
  }

  Future<void> _onDelete(ToDoModel todo) async {
    try {
      if (todo.id == null) return;
      final int deletedId = todo.id!;
      debugPrint('deletedTodo Todo: ${todo.toJson()}');
      await DatabaseService.instance.deleteToDo(deletedId);
      await _loadTodosFromDataBase();
      debugPrint('deletedId Todo: $deletedId');
    } catch (e) {
      debugPrint('Error deleting todo: $e');
    }
  }

  Future<void> _toggleSelectAll(List<ToDoModel> currentTodos) async {
    bool allChecked = currentTodos.every((todo) => todo.isChecked);
    for (var todo in currentTodos) {
      todo.isChecked = !allChecked;
      todo.updatedDate = todo.isChecked ? DateTime.now() : null;
      await DatabaseService.instance.updateToDo(todo);
    }
    await _loadTodosFromDataBase();
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLogin');
    await prefs.remove('name');
    _navigateToLogin();
  }

  void _navigateToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  void _bottomSheetPop() {
    Navigator.pop(context);
  }

  void _configureScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isFabVisible.value) {
          _isFabVisible.value = false;
        }
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isFabVisible.value) {
          _isFabVisible.value = true;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTodosFromDataBase();
    _configureScrollListener();
  }

  @override
  void dispose() {
    _todoStreamController.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _todoStreamController.stream,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              color: Colors.green,
            ),
          );
        }

        final todos = asyncSnapshot.data ?? [];
        return CustomScaffold(
          actions: [
            IconButton(
              onPressed: () => _toggleSelectAll(todos),
              icon: Icon(
                _areAllSelected
                    ? Icons.check_box_outlined
                    : Icons.check_box_outline_blank,
                color: _areAllSelected ? Colors.green : Colors.black,
                size: 28,
              ),
            ),

            IconButton(
              onPressed: _logout,
              icon: Icon(Icons.logout_outlined, color: Colors.black, size: 32),
            ),
          ],
          title: 'ToDo App',
          floatingActionButton: ValueListenableBuilder(
            valueListenable: _isFabVisible,
            builder: (context, isVisible, child) {
              return AnimatedSlide(
                offset: isVisible ? Offset.zero : Offset(0, 1),
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child:  isVisible ? FloatingActionButton(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  elevation: 10,
                  onPressed: () {
                    _showBottomSheet(context);
                  },
                  child: const Icon(Icons.add),
                ) : const SizedBox.shrink(),
              );
            }
          ),

          child: todos.isEmpty
              ? Center(
                  child: Text(
                    'Welcome ${widget.name} to ToDo App!\nNo tasks added yet!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.only(bottom: 80),
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return ToDoCard(
                      onTapCheck: () => _onCheckToggle(todo),
                      toDoModel: todo,
                      onTapDelete: () => _onDelete(todo),
                      onTapEdit: () {
                        _showBottomSheet(
                          context,
                          isEdit: true,
                          toDoItem: todo,
                          // position: index,
                        );
                      },
                    );
                  },
                ),
        );
      },
    );
  }

  Future<dynamic> _showBottomSheet(
    BuildContext context, {
    bool isEdit = false,
    ToDoModel? toDoItem,
    // int? position,
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
      isDismissible: true,
      isScrollControlled: true,
      enableDrag: true,
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
                  textInputAction: TextInputAction.done,
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
                      if (isEdit && toDoItem != null) {
                        _editTodo(toDoItem, title, description, selectedColor);
                      } else {
                        _addTodo(title, description, selectedColor);
                      }
                    } else {
                      ScaffoldMessenger.of(this.context).showSnackBar(
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

  Future<void> _addTodo(
    String title,
    String description,
    Color? selectedColor,
  ) async {
    final newTodo = ToDoModel(
      isChecked: false,
      title: title,
      description: description,
      createdDate: DateTime.now(),
      todoItemColor: selectedColor,
    );
    final int id = await DatabaseService.instance.insertToDo(newTodo);
    newTodo.id = id;
    _loadTodosFromDataBase();
  }

  Future<void> _editTodo(
    ToDoModel todo,
    String title,
    String description,
    Color? selectedColor,
  ) async {
    todo.title = title;
    todo.description = description;
    todo.todoItemColor = selectedColor;
    todo.updatedDate = DateTime.now();
    await DatabaseService.instance.updateToDo(todo);
    _loadTodosFromDataBase();
    debugPrint('Updated Todo: ${todo.toJson()}');
  }
}
