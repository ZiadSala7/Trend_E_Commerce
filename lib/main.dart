import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_colors.dart';
import 'core/di/injection.dart';
import 'presentation/providers/pos_provider.dart';
import 'presentation/screens/pos_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const ECommerceTrendApp());
}

class ECommerceTrendApp extends StatelessWidget {
  const ECommerceTrendApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PosProvider(),
      child: MaterialApp(
        title: 'E-Commerce Trend',
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
