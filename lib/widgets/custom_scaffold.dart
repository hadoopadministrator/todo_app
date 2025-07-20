import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final Widget child;
  final String? title;
  final Widget? floatingActionButton;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;
  const CustomScaffold({
    super.key,
    required this.child,
    this.title,
    this.floatingActionButton,
    this.automaticallyImplyLeading = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        actions: actions,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: automaticallyImplyLeading,
        elevation: 0.2,
        title: Text(
          title ?? '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.green,
          ),
        ),
      ),
      body: SafeArea(child: child),

      floatingActionButton: floatingActionButton,
    );
  }
}
