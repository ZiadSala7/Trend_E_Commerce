import 'package:flutter/material.dart';

import 'core/di/injection.dart';
import 'e_commerce_trend_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const ECommerceTrendApp());
}
