import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/pos_provider.dart';
import '../widgets/invoice_panel.dart';
import '../widgets/product_catalog.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({super.key});

  @override
  State<MobileLayout> createState() => MobileLayoutState();
}

class MobileLayoutState extends State<MobileLayout> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: IndexedStack(
            index: _selectedIndex,
            children: [ProductCatalog(), const InvoicePanel()],
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
