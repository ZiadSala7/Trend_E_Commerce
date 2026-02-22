import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/breakpoints.dart';
import '../providers/pos_provider.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < Breakpoints.tablet;
    return Consumer<PosProvider>(
      builder: (context, provider, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(right: isMobile ? 12 : 16),
          child: Row(
            children: provider.categories.map((cat) {
              final isSelected = provider.selectedCategoryId == cat.id;
              return Padding(
                padding: EdgeInsets.only(right: isMobile ? 6 : 8),
                child: FilterChip(
                  label: Text(cat.name),
                  selected: isSelected,
                  onSelected: (_) => provider.setCategory(cat.id),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontSize: isMobile ? 12 : 14,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 10 : 12,
                    vertical: isMobile ? 8 : 10,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
