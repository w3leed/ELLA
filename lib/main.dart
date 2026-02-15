import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:raf/core/responsive_wrapper.dart';
import 'package:raf/core/constants.dart';

import 'package:raf/cubit/app/app_cubit.dart';
import 'package:raf/new_app/app_layout/main_layout.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(tUId);
  // SupabaseManager.init();

  const supabaseUrl = 'https://ztbsjnpqmqzeszyodpcb.supabase.co';
  const supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp0YnNqbnBxbXF6ZXN6eW9kcGNiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzExMzgyMTEsImV4cCI6MjA4NjcxNDIxMX0.LnCltsqQcPVpZi9W3mcDVMSG2Ym9yJqavCGCefrCu10';

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AppCubit()
            ..getoffer()
            ..getSpecialOffers()
            ..getUserProfile(),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            secondary: AppColors.secondary,
            background: AppColors.background,
            surface: AppColors.cardBackground,
          ),
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.background,
            elevation: 0,
            iconTheme: IconThemeData(color: AppColors.textDark),
            titleTextStyle: TextStyle(
              color: AppColors.textDark,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          fontFamily: 'Cairo',
        ),
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale("en")],
        locale: const Locale("en"),
        debugShowCheckedModeBanner: false,
        initialRoute: "/home",
        routes: {"/home": (_) => const MainLayout()},
        builder: (context, child) {
          return ResponsiveWrapper(child: child!);
        },
      ),
    );
  }
}
