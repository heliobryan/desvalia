// ignore_for_file: deprecated_member_use

import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class FilterCategory extends StatelessWidget {
  final String? selectedCategory;
  final Function(String?) onCategorySelected;

  const FilterCategory({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = ['SUB 9', 'SUB 10', 'SUB 11', 'SUB 12'];

    return Container(
      width: 120,
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0XFFb0c32e)),
        borderRadius: BorderRadius.circular(8),
        color: Colors.black.withOpacity(0.3),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: Colors.grey[900],
          value: selectedCategory,
          iconEnabledColor: Colors.white,
          style: secondFont.bold(color: Colors.white),
          hint: Text("Categoria", style: secondFont.bold(color: Colors.white)),
          items: categories.map((category) {
            return DropdownMenuItem<String>(
              value: category,
              child:
                  Text(category, style: secondFont.bold(color: Colors.white)),
            );
          }).toList(),
          onChanged: onCategorySelected,
        ),
      ),
    );
  }
}
