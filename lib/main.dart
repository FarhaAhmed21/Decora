import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/core/l10n/local_cubit.dart';
import 'package:decora/firebase_options.dart';
import 'package:decora/src/features/notifications/services/notification.dart';
import 'package:decora/src/features/notifications/services/notifications_services.dart';
import 'package:decora/src/features/splash/cubit/splash_cubit.dart';
import 'package:decora/src/features/splash/screens/splash_screen.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  await NotificationMessage.initialize();
  
  // NotificationMessage.showNotification(
  //   title: "New Message",
  //   message: "You have a new friend request!",
  // );

  // await NotificationService.addNotification(
  //     "Welcome back!",
  //     "You just logged in again.",
  //   );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppThemeProvider()),
        BlocProvider(create: (_) => LocaleCubit()),
        BlocProvider(create: (_) => SplashCubit()),
      ],
      child: ChangeNotifierProvider(
        create: (_) => AppThemeProvider(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<AppThemeProvider>(context);

    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('ar')],
          theme: themeProvider.currentTheme,
          home: const SplashScreen(),
        );
      },
    );
  }
}

