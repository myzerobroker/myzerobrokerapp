import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final String label;
  final bool initialValue;
  final void Function(bool?)? onChanged;

  const CustomCheckbox({
    Key? key,
    required this.label,
    required this.initialValue,
    this.onChanged,
  }) : super(key: key);

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _isChecked,
          onChanged: (bool? value) {
            setState(() {
              _isChecked = value ?? false;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          },
        ),
        Text(
          widget.label,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
