import 'package:flutter/material.dart';

Future<DateTime?> pickDueDate(BuildContext context) async {
  final now = DateTime.now();
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: now,
    firstDate: now,
    lastDate: DateTime(2050),
  );

  return picked;
} //pick Due Date
