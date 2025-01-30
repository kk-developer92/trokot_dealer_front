import 'package:flutter/material.dart';
import 'model_ref.dart';

class ModelField<T extends ModelRef> extends StatelessWidget {
  final T? value;
  final Future<T?> Function({required BuildContext context, T? currentItem}) openPicker;
  final ValueChanged<T?>? onChanged;
  final InputDecoration? decoration;

  const ModelField({
    super.key,
    required this.value,
    required this.openPicker,
    this.onChanged,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: value?.repr ?? ''),
      decoration: decoration?.copyWith(
        suffixIcon: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            if (onChanged != null) {
              onChanged!(null);
            }
          },
        ),
      ),
      readOnly: true,
      onTap: () async {
        final pickedValue = await openPicker(context: context, currentItem: value);
        if (pickedValue != null && onChanged != null) {
          onChanged!(pickedValue);
        }
      },
    );
  }
}
