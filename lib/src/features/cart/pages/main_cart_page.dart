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
import 'package:decora/src/features/product_details/models/product_model.dart';
import 'package:decora/src/features/product_details/services/product_services.dart';
import 'package:decora/src/payment/screen/payment-screen.dart';
import 'package:decora/src/payment/repo/paymob-service.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartBloc(CartRepository())..add(LoadCartTotalsEvent()),
      child: const MainCartPage(),
    );
  }
}

class MainCartPage extends StatefulWidget {
  const MainCartPage({super.key});

  @override
  State<MainCartPage> createState() => _MainCartPageState();
}

class _MainCartPageState extends State<MainCartPage> {
  bool isSheetOpen = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  double taxes = 0.2;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: scaffoldKey,
        appBar: const CartAppBar(),
        body: const TabBarView(children: [MyCart(), SharedCart()]),
        bottomNavigationBar: Builder(
          builder: (context) {
            final TabController controller = DefaultTabController.of(context);

            return AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                if (controller.index == 1) return const SizedBox.shrink();
                return Container(
                  height: AppSize.height(context) * 0.13,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 3,
                  ),
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
                            handlePayNow(context);
                          } else {
                            openCheckoutSheet(context);
                          }
                        },
                        child: Text(
                          isSheetOpen
                              ? AppLocalizations.of(context)!.pay_now
                              : AppLocalizations.of(context)!.checkout,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void handlePayNow(BuildContext ctx) async {
    try {
      final cartState = ctx.read<CartBloc>().state;

      final subtotal = cartState.initialTotal;
      final discount = cartState.initialTotal - cartState.discountedTotal;
      final taxesAmount = cartState.discountedTotal * taxes;
      final finalTotal = cartState.discountedTotal + taxesAmount;

      if (finalTotal <= 0) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(content: Text("Total amount must be greater than 0")),
        );
        return;
      }

      final amountCents = (finalTotal * 100).toInt();

      final authToken = await PaymobService.getAuthToken();
      if (authToken.isEmpty) throw Exception("Auth token empty");

      final orderId = await PaymobService.createOrder(
        authToken: authToken,
        amountCents: amountCents,
      );

      final paymentKey = await PaymobService.getPaymentKey(
        authToken: authToken,
        orderId: orderId,
        amountCents: amountCents,
      );

      if (paymentKey.isEmpty) throw Exception("Payment key empty");

      final paymentUrl = PaymobService.getPaymentUrl(paymentKey);

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(ctx)!.redirecting_to_payment_gateway,
          ),
        ),
      );

      await OrderService.addOrderFromCart(
        amount: finalTotal.toString(),
        isShared: false,
        context: ctx,
      );

      // Wait for PaymentScreen to close
      final result = await Navigator.push(
        ctx,
        MaterialPageRoute(
          builder: (_) => PaymentScreen(paymentUrl: paymentUrl),
        ),
      );

      if (result != null && result == true) {
        final userId = FirebaseAuth.instance.currentUser!.uid;
        await ProductService().reduceStockFromCart(userId);

        ctx.read<CartBloc>().add(LoadCartTotalsEvent());
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(content: Text("Payment completed successfully!")),
        );
      } else {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(content: Text("Payment cancelled or failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(
              ctx,
            )!.an_error_occurred_while_processing_the_payment,
          ),
        ),
      );
    }
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

              Expanded(
                child: BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    final subtotal = state.initialTotal;
                    final discount = state.initialTotal - state.discountedTotal;
                    final taxesAmount = state.discountedTotal * taxes;
                    final total = state.discountedTotal + taxesAmount;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sheetPaymentRow(
                          context,
                          AppLocalizations.of(context)!.sub_total,
                          subtotal,
                        ),
                        sheetPaymentRow(
                          context,
                          AppLocalizations.of(context)!.discount,
                          discount,
                        ),
                        sheetPaymentRow(
                          context,
                          AppLocalizations.of(context)!.taxes,
                          taxesAmount,
                        ),
                        const Divider(color: Colors.grey),
                        sheetPaymentRow(
                          context,
                          AppLocalizations.of(context)!.total,
                          total,
                        ),
                      ],
                    );
                  },
                ),
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
