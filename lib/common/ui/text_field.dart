import 'package:flutter/material.dart';

class AppTextFieldNull extends StatefulWidget {
  final String? text;
  final InputDecoration? decoration;
  final ValueChanged<String?> onChanged;

  const AppTextFieldNull({
    super.key,
    required this.text,
    this.decoration,
    required this.onChanged,
  });

  @override
  State<AppTextFieldNull> createState() => _AppTextFieldNullState();
}

class _AppTextFieldNullState extends State<AppTextFieldNull> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.text);
  }

  @override
  void didUpdateWidget(covariant AppTextFieldNull oldWidget) {
    super.didUpdateWidget(oldWidget);

    final String newText;
    if (widget.text == null) {
      newText = '';
    } else {
      newText = widget.text!;
    }
    if (controller.text != newText) {
      controller.text = widget.text!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: widget.decoration?.copyWith(
        suffixIcon: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            controller.text = '';
            widget.onChanged(null);
          },
        ),
      ),
      onChanged: widget.onChanged,
    );
  }
}

class AppTextField extends StatefulWidget {
  final String text;
  final InputDecoration? decoration;
  final bool obscureText;
  final bool closeButton;
  final ValueChanged<String> onChanged;
  final int maxLines;

  const AppTextField({
    super.key,
    required this.text,
    this.decoration,
    this.obscureText = false,
    this.closeButton = true,
    required this.onChanged,
    this.maxLines = 1,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.text);
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (controller.text != widget.text) {
      controller.text = widget.text;
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration? decoration;

    if (widget.decoration != null) {
      if (widget.closeButton) {
        decoration = widget.decoration!.copyWith(
          suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              controller.text = '';
              widget.onChanged('');
            },
          ),
        );
      } else {
        decoration = widget.decoration;
      }
    } else {
      if (widget.closeButton) {
        decoration = InputDecoration(
          suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              controller.text = '';
              widget.onChanged('');
            },
          ),
        );
      }
    }

    return TextField(
      maxLines: widget.maxLines,
      controller: controller,
      decoration: decoration,            
      obscureText: widget.obscureText,
      onChanged: widget.onChanged,
    );
  }
}
