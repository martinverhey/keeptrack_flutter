import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../expenses/cubit/expenses_cubit.dart';
import '../expenses/models/expense.model.dart';

class CategoryFilter extends StatelessWidget {
  final List<ExpenseCategory> selectedCategories;

  const CategoryFilter({
    Key? key,
    required this.selectedCategories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Wrap(
    //   alignment: WrapAlignment.start,
    //   crossAxisAlignment: WrapCrossAlignment.start,
    //   spacing: 8,
    //   children: [
    //     for (final category in ExpenseCategory.values)
    //       Chip(
    //         label: Text(category.name),
    //         labelPadding: const EdgeInsets.fromLTRB(4, 0, 2, 0),
    //         backgroundColor: category.color,
    //         labelStyle: const TextStyle(color: Colors.white),
    //         onDeleted: () {
    //           context.read<ExpensesCubit>().setFilter(category);
    //           context.read<ExpensesCubit>().getAll();
    //           print('remove filter: ${category.name}');
    //         },
    //         deleteIconColor: Colors.white,
    //         visualDensity: const VisualDensity(horizontal: 0.0, vertical: -4),
    //       ),
    //   ],
    // );
    return SizedBox(
      height: 56,
      child: ListView.separated(
        padding: const EdgeInsets.only(left: 16, right: 16),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: ExpenseCategory.values.length,
        itemBuilder: (context, index) {
          ExpenseCategory category = ExpenseCategory.values[index];
          return FilterChip(
            label: Text(category.name),
            labelStyle: TextStyle(
              color: selectedCategories.contains(category) ? Colors.white : null,
            ),
            checkmarkColor: Colors.white,
            selectedColor: category.color,
            selected: selectedCategories.contains(category),
            onSelected: (isSelected) async {
              context.read<ExpensesCubit>().setFilter(category);
              context.read<ExpensesCubit>().getAll();
            },
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    Key? key,
    required this.name,
    required this.color,
    this.isSelected = false,
    required this.onToggle,
  }) : super(key: key);
  final String name;
  final Color color;
  final bool isSelected;
  final Function() onToggle;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      onPressed: onToggle,
      label: Text(
        name,
        style: isSelected ? const TextStyle(color: Colors.white) : null,
      ),
      backgroundColor: isSelected ? color : null,
    );
  }
}
