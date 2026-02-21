import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/breakpoints.dart';
import '../providers/pos_provider.dart';
import '../widgets/product_grid.dart';
import 'mobile_layout.dart';
import 'tablet_layout.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  State<PosScreen> createState() => PosScreenState();
}

class PosScreenState extends State<PosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PosProvider>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = Breakpoints.isTablet(constraints.maxWidth);
            if (isTablet) {
              return TabletLayout();
            }
            return MobileLayout();
          },
        ),
      ),
    );
  }
}

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
              SearchBar(isMobile: isMobile),
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

class SearchBar extends StatelessWidget {
  const SearchBar({super.key, required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Consumer<PosProvider>(
      builder: (context, provider, _) {
        return TextField(
          decoration: InputDecoration(
            hintText: 'Search Products...',
            prefixIcon: Icon(Icons.search, size: isMobile ? 20 : 24),
            filled: true,
            fillColor: Colors.white,
            isDense: isMobile,
            contentPadding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 16,
              vertical: isMobile ? 12 : 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: provider.setSearch,
        );
      },
    );
  }
}

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
