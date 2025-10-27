import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/core/l10n/local_cubit.dart';
import 'package:decora/firebase_options.dart';
import 'package:decora/src/features/cart/pages/main_cart_page.dart';
import 'package:decora/src/features/splash/cubit/splash_cubit.dart';
import 'package:decora/src/features/splash/screens/splash_screen.dart';

import 'package:decora/src/payment/repo/paymob-service.dart';

import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('🔥 Firebase initialized successfully');

  await dotenv.load(fileName: ".env");
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LocaleCubit()),
        BlocProvider(create: (_) => SplashCubit()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
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

          home: const MainCartPage(),

          theme: ThemeData(
            fontFamily: 'Montserratt',
            scaffoldBackgroundColor: AppColors.background(),
          ),
        );
      },
    );
  }
}

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;
//     return Scaffold(
//       appBar: AppBar(title: Text(l10n.helloWorld)),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             //SearchBarWithFilter(),
//             Text(l10n.welcome),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 context.read<LocaleCubit>().toggleLocale();
//               },
//               child: Text(l10n.changeLanguage),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
