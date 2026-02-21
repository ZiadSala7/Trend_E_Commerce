import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/breakpoints.dart';
import '../providers/pos_provider.dart';
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
