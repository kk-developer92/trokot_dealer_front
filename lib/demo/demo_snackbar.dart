import 'package:flutter/material.dart';

class SnackBarScreen extends StatelessWidget {
  const SnackBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Content here'),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: Icon(Icons.add_alert),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text('Произошла ошибка доступа к серверу'),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            child: Icon(Icons.abc_sharp),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
