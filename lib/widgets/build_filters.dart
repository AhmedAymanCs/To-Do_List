import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_list/constant/enums.dart';

class BuildFilters extends StatelessWidget {
  TaskFilter selectedFilter;
  final Function(TaskFilter) onSelected;
  BuildFilters({
    super.key,
    required this.selectedFilter,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(TaskFilter.values.length, (index) {
            final filter = TaskFilter.values[index];
            final bool isSelected = selectedFilter == filter;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: ChoiceChip(
                label: Text(filter.name.toUpperCase()),
                selected: isSelected,
                onSelected: (_) => onSelected(TaskFilter.values[index]),
              ),
            );
          }),
        ],
      ),
    );
  }
}
