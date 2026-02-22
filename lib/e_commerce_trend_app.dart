import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_colors.dart';
import 'features/home/presentation/providers/pos_provider.dart';
import 'features/home/presentation/screens/pos_screen.dart';

class ECommerceTrendApp extends StatelessWidget {
  const ECommerceTrendApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PosProvider(),
      child: MaterialApp(
        title: 'Trend',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
        ),
        home: const PosScreen(),
      ),
    );
  }
}
