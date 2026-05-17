import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/colors.dart';
import 'screens/dashboard_page.dart';
import 'screens/login_page.dart';

Future<void> main() async {
  // Pastikan inisialisasi Flutter sudah siap
  WidgetsFlutterBinding.ensureInitialized();

  // Ambil data token dari SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  // Jalankan aplikasi dengan membawa informasi status login
  runApp(BankSampahApp(isLoggedIn: token != null));
}

class BankSampahApp extends StatelessWidget {
  final bool isLoggedIn;

  const BankSampahApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bank Sampah Sungailiat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Tema Neobrutalism: warna dasar hijau, font tebal
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryGreen,
          surface: AppColors.bgColor,
        ),
        scaffoldBackgroundColor: AppColors.bgColor,
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      // Rute awal diarahkan ke halaman login atau dashboard berdasarkan status token
      initialRoute: isLoggedIn ? '/dashboard' : '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}
