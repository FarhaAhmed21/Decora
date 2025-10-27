import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/core/utils/app_size.dart';
import 'package:decora/src/features/cart/pages/my_cart.dart';
import 'package:decora/src/features/cart/pages/shared_cart.dart';
import 'package:decora/src/features/cart/widgets/cart_app_bar.dart';
import 'package:decora/src/payment/screen/payment-screen.dart';
import 'package:decora/src/payment/repo/paymob-service.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class MainCartPage extends StatefulWidget {
  const MainCartPage({super.key});

  @override
  State<MainCartPage> createState() => _MainCartPageState();
}

class _MainCartPageState extends State<MainCartPage> {
  bool isSheetOpen = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  final double taxes = 0;
  final double subTotal = 1300;
  final double discount = 120;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: scaffoldKey,
        appBar: const CartAppBar(),
        body: const TabBarView(children: [MyCart(), SharedCart()]),

        bottomNavigationBar: Container(
          height: AppSize.height(context) * 0.13,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 3),
          color: AppColors.background(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary(),
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
    );
  }

  void handlePayNow() async {
    try {
      final authToken = await PaymobService.getAuthToken();
      print("🔹 Auth Token: $authToken");

      final orderId = await PaymobService.createOrder(
        authToken: authToken,
        amountCents: ((subTotal + taxes - discount) * 100).toInt(),
      );
      print("🔹 Order ID: $orderId");

      final paymentKey = await PaymobService.getPaymentKey(
        authToken: authToken,
        orderId: orderId,
        amountCents: ((subTotal + taxes - discount) * 100).toInt(),
      );
      print("🔹 Payment Key: $paymentKey");

      // 4️⃣ Generate payment URL
      final paymentUrl = PaymobService.getPaymentUrl(paymentKey);
      print("🔹 Payment URL: $paymentUrl");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(paymentUrl: paymentUrl),
        ),
      );
    } catch (e) {
      print("❌ Payment Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ أثناء تنفيذ عملية الدفع")),
      );
    }
  }

  void openCheckoutSheet(BuildContext context) {
    setState(() => isSheetOpen = true); // ✅ toggle button

    scaffoldKey.currentState!.showBottomSheet(
      (context) => Container(
        color: AppColors.background(),
        width: AppSize.width(context),
        height: AppSize.height(context) * 0.42,
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
                        color: AppColors.mainText(),
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
                  color: AppColors.mainText(),
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
                        color: AppColors.textColor(),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintStyle: TextStyle(color: AppColors.textColor()),
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
                  color: AppColors.textColor(),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              sheetPaymentrRow(
                context,
                AppLocalizations.of(context)!.sub_total,
                subTotal,
              ),
              const SizedBox(height: 10),
              sheetPaymentrRow(
                context,
                AppLocalizations.of(context)!.taxes,
                taxes,
              ),
              const SizedBox(height: 10),
              sheetPaymentrRow(
                context,
                AppLocalizations.of(context)!.discount,
                -discount,
              ),
              const SizedBox(height: 10),
              Divider(color: Colors.grey[300]),
              sheetPaymentrRow(
                context,
                AppLocalizations.of(context)!.total,
                taxes + subTotal - discount,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row sheetPaymentrRow(BuildContext context, String name, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: TextStyle(
            color: AppColors.textColor(),
            fontSize: 16,
            fontWeight: name == AppLocalizations.of(context)!.total
                ? FontWeight.w600
                : FontWeight.w400,
          ),
        ),
        Text(
          "$amount EGP",
          style: TextStyle(
            color: AppColors.textColor(),

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
