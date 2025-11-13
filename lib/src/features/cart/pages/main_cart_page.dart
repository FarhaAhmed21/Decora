import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/core/utils/app_size.dart';
import 'package:decora/src/features/cart/bloc/cart_bloc.dart';
import 'package:decora/src/features/cart/bloc/cart_event.dart';
import 'package:decora/src/features/cart/bloc/cart_state.dart';
import 'package:decora/src/features/cart/pages/my_cart.dart';
import 'package:decora/src/features/cart/pages/shared_cart.dart';
import 'package:decora/src/features/cart/service/service.dart';
import 'package:decora/src/features/cart/widgets/cart_app_bar.dart';
import 'package:decora/src/features/myOrders/service/order_service.dart';
import 'package:decora/src/payment/screen/payment-screen.dart';
import 'package:decora/src/payment/repo/paymob-service.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainCartPage extends StatefulWidget {
  const MainCartPage({super.key});

  @override
  State<MainCartPage> createState() => _MainCartPageState();
}

class _MainCartPageState extends State<MainCartPage> {
  bool isSheetOpen = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  double taxes = 30;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartBloc(CartRepository())..add(LoadCartTotalsEvent()),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          key: scaffoldKey,
          appBar: const CartAppBar(),
          body: const TabBarView(children: [MyCart(), SharedCart()]),

          bottomNavigationBar: Container(
            height: AppSize.height(context) * 0.13,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 3),
            color: AppColors.background(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 20,
              ),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (isSheetOpen) {
                      handlePayNow();
                    } else {
                      openCheckoutSheet(context);
                    }
                  },
                  child: Text(
                    isSheetOpen
                        ? AppLocalizations.of(context)!.pay_now
                        : AppLocalizations.of(context)!.checkout,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void handlePayNow() async {
    try {
      final cartState = context.read<CartBloc>().state;
      final subtotal = cartState.initialTotal;
      final discounted = cartState.discountedTotal;
      final taxes = 30;

      final finalTotal = subtotal - discounted + taxes;

      if (finalTotal <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Total amount must be greater than 0")),
        );
        return;
      }

      // Add order from cart with correct amount
      await OrderService.addOrderFromCart(
        amount: finalTotal.toString(), // use finalTotal here
        isShared: false,
      );

      // Get Paymob token
      final authToken = await PaymobService.getAuthToken();
      if (authToken.isEmpty) {
        throw Exception("Failed to get Paymob auth token");
      }

      // Create order
      final orderId = await PaymobService.createOrder(
        authToken: authToken,
        amountCents: (finalTotal * 100).toInt(),
      );

      // Get payment key
      final paymentKey = await PaymobService.getPaymentKey(
        authToken: authToken,
        orderId: orderId,
        amountCents: (finalTotal * 100).toInt(),
      );

      final paymentUrl = PaymobService.getPaymentUrl(paymentKey);

      print("✅ Order created successfully");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(paymentUrl: paymentUrl),
        ),
      );
    } catch (e, st) {
      print("❌ Payment Error: $e\n$st");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(
              context,
            )!.an_error_occurred_while_processing_the_payment,
          ),
        ),
      );
    }
    await OrderService.addOrderFromCart( //TODO: FOR TESTING ONLY
        amount: "1000",
        isShared: false,
      );

  }

  void openCheckoutSheet(BuildContext context) {
    setState(() => isSheetOpen = true);

    scaffoldKey.currentState!.showBottomSheet(
      (context) => Container(
        color: AppColors.background(context),
        width: AppSize.width(context),
        height: AppSize.height(context) * 0.43,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: AppSize.width(context) * 0.35,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.checkout,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppColors.mainText(context),
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() => isSheetOpen = false);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              Text(
                AppLocalizations.of(context)!.promo_code,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.mainText(context),
                ),
              ),
              const SizedBox(height: 15),
              // Promo field
              SizedBox(
                width: AppSize.width(context) * 0.96,
                height: 60,
                child: TextField(
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.textColor(context),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintStyle: TextStyle(color: AppColors.textColor(context)),
                    hintText: AppLocalizations.of(context)!.enter_promo_code,
                    suffixIcon: SizedBox(
                      width: 110,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 136, 173, 143),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.avilable,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                AppLocalizations.of(context)!.payment_summary,
                style: TextStyle(
                  color: AppColors.textColor(context),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  return sheetPaymentRow(
                    context,
                    AppLocalizations.of(context)!.sub_total,
                    state.initialTotal,
                  );
                },
              ),
              const SizedBox(height: 10),

              // 🧾 Taxes
              sheetPaymentRow(
                context,
                AppLocalizations.of(context)!.taxes,
                taxes,
              ),
              const SizedBox(height: 10),

              // 🧾 Discount
              BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  return sheetPaymentRow(
                    context,
                    AppLocalizations.of(context)!.discount,
                    state.initialTotal - state.discountedTotal,
                  );
                },
              ),
              const SizedBox(height: 10),
              Divider(color: Colors.grey[300]),

              // 🧾 Total
              BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  return sheetPaymentRow(
                    context,
                    AppLocalizations.of(context)!.total,
                    state.discountedTotal + taxes,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row sheetPaymentRow(BuildContext context, String name, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: TextStyle(
            color: AppColors.textColor(context),
            fontSize: 16,
            fontWeight: name == AppLocalizations.of(context)!.total
                ? FontWeight.w600
                : FontWeight.w400,
          ),
        ),
        Text(
          "$amount \$",
          style: TextStyle(
            color: AppColors.textColor(context),

            fontSize: 16,
            fontWeight: name == AppLocalizations.of(context)!.total
                ? FontWeight.w600
                : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
