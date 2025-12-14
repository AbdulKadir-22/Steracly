import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/local/hive_init.dart';

// App data
import 'package:google_fonts/google_fonts.dart';
import 'core/constants/app_colors.dart';

// Screens
import 'presentation/screens/onboarding/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveInit.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
        // This applies Inter font globally
        textTheme: GoogleFonts.interTextTheme(),
      ),
      title: 'Streakly',
      debugShowCheckedModeBanner: false,
      home: const OnboardingScreen(),
    );
  }
}
