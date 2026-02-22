import 'package:flutter/material.dart';

import '../../../../core/constants/breakpoints.dart';
import 'category_chips.dart';
import 'search_bar.dart';
import 'product_grid.dart';

class ProductCatalog extends StatelessWidget {
  const ProductCatalog({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < Breakpoints.tablet;
    final padding = isMobile ? 12.0 : 16.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSearchBar(isMobile: isMobile),
              SizedBox(height: isMobile ? 10 : 12),
              const CategoryChips(),
            ],
          ),
        ),
        const Expanded(child: ProductGrid()),
      ],
    );
  }
}
