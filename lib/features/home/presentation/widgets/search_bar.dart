import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/pos_provider.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({super.key, required this.isMobile});

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
