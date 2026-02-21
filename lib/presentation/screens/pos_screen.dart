import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/breakpoints.dart';
import '../providers/pos_provider.dart';
import '../widgets/invoice_panel.dart';
import '../widgets/product_grid.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
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
              return _TabletLayout();
            }
            return _MobileLayout();
          },
        ),
      ),
    );
  }
}

class _TabletLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: _ProductCatalog()),
        Flexible(flex: 1, child: InvoicePanel()),
      ],
    );
  }
}

class _MobileLayout extends StatefulWidget {
  @override
  State<_MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<_MobileLayout> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: IndexedStack(
            index: _selectedIndex,
            children: [_ProductCatalog(), const InvoicePanel()],
          ),
        ),
        Consumer<PosProvider>(
          builder: (context, provider, _) {
            return BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (i) => setState(() => _selectedIndex = i),
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag_outlined),
                  label: 'Products',
                ),
                BottomNavigationBarItem(
                  icon: Badge(
                    label: Text('${provider.cartItemCount}'),
                    isLabelVisible: provider.cartItemCount > 0,
                    child: const Icon(Icons.receipt_long_outlined),
                  ),
                  label: 'Invoice',
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ProductCatalog extends StatelessWidget {
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
              _SearchBar(isMobile: isMobile),
              SizedBox(height: isMobile ? 10 : 12),
              const _CategoryChips(),
            ],
          ),
        ),
        const Expanded(child: ProductGrid()),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.isMobile});

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

class _CategoryChips extends StatelessWidget {
  const _CategoryChips();

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
