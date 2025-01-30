import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppDecimalField extends StatefulWidget {
  final Decimal value;
  final Function(Decimal) onChanged;

  final InputDecoration? decoration;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;

  const AppDecimalField({
    super.key,
    required this.value,
    required this.onChanged,
    this.decoration,
    this.style,
    this.textAlign,
    this.textAlignVertical,
  });

  @override
  State<AppDecimalField> createState() => _AppDecimalFieldState();
}

class _AppDecimalFieldState extends State<AppDecimalField> {
  final FocusNode focusNode = FocusNode();
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void didUpdateWidget(AppDecimalField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value) {
      controller.text = widget.value.toString();
    }
    focusNode.addListener(() {
      if (focusNode.hasFocus == false) {
        // print('Focus lost... ${DateTime.now()}');
        onEditingComplete();
      }
    });
  }

  @override
  void dispose() {
    // onEditingComplete();

    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void onEditingComplete() {
    // print('onEditingComplete()... ${DateTime.now()}');
    final stringValue = controller.text;
    final decimalValue = stringValue.isEmpty ? Decimal.zero : Decimal.parse(stringValue);
    widget.onChanged(decimalValue);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: widget.decoration,
      textAlign: widget.textAlign ?? TextAlign.start,
      textAlignVertical: widget.textAlignVertical,
      keyboardType: TextInputType.number,
      // keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],

      scrollPadding: EdgeInsets.zero,

      style: widget.style,
      onEditingComplete: onEditingComplete,
      // onSubmitted: (value) {
      //   final decimalValue = value.isEmpty ? Decimal.zero : Decimal.parse(value);
      //   widget.onChanged(decimalValue);
      // },
    );
  }
}
