// import 'package:decora/src/features/Auth/screens/login_screen.dart';
// import 'package:decora/src/features/Auth/screens/signup_screen.dart';
// import 'package:decora/src/features/cart/pages/main_cart_page.dart';
// import 'package:decora/src/features/home/screens/home_screen.dart';
// import 'package:decora/src/features/onboarding/screens/onboarding_screen.dart';
// import 'package:decora/src/features/product_details/screens/product_details_screen.dart';
// import 'package:decora/src/features/splash/screens/splash_screen.dart';
// import 'package:flutter/material.dart';

// class Routes {
//   static const String splash = '/';
//   static const String onboarding = '/onboarding';
//   static const String login = '/login';
//   static const String register = '/register';
//   static const String home = '/home';
//   static const String myCart = '/my_cart';
//   static const String productDetail = '/product_detail';
//   static const String orderDetails = '/order_details';
//   static const String orderItems = '/order_items';
// }

// class AppRoutes {
//   static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case Routes.splash:
//         return MaterialPageRoute(builder: (_) => const SplashScreen());

//       case Routes.onboarding:
//         return MaterialPageRoute(builder: (_) => const OnboardingScreen());

//       case Routes.login:
//         return MaterialPageRoute(builder: (_) => const LoginScreen());

//       case Routes.register:
//         return MaterialPageRoute(builder: (_) => const SignUpScreen());

//       case Routes.home:
//         return MaterialPageRoute(builder: (_) => const HomeScreen());

//       case Routes.myCart:
//         return MaterialPageRoute(builder: (_) => const MainCartPage());

//       case Routes.productDetail:
//         final product = settings.arguments;
//         return MaterialPageRoute(builder: (_) => const ProductDetailsScreen());

//       case Routes.orderDetails:
//         final order = settings.arguments;
//         return MaterialPageRoute(
//           builder: (_) => order,
//         );

//       case Routes.orderItems:
//         final items = settings.arguments;
//         return MaterialPageRoute(
//           builder: (_) => OrderItemsScreen(items: items),
//         );

//       default:
//         return MaterialPageRoute(
//           builder: (_) =>
//               const Scaffold(body: Center(child: Text('404 - Page Not Found'))),
//         );
//     }
//   }
// }
