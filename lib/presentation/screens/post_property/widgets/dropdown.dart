import 'package:flutter/material.dart';
class DropdownField extends StatelessWidget {
  final String label;
  final List<String> items;
  final String fieldKey;
  final String? value;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator; // Correctly define the validator type

  const DropdownField({
    required this.label,
    required this.items,
    required this.fieldKey,
    Key? key,
    this.value,
    this.onChanged,
    this.validator, // Accept validator as a parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        items: items
            .map((item) =>
                DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
        validator: validator, // Use the validator property here
      ),
    );
  }
}