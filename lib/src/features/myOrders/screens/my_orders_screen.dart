import 'package:decora/src/features/myOrders/service/order_service.dart';
import 'package:decora/src/features/myOrders/widgets/order_container.dart';
import 'package:decora/src/features/myOrders/widgets/top_slider.dart';
import 'package:decora/src/shared/components/appbar.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyOrdesScreen extends StatefulWidget {
  const MyOrdesScreen({super.key});

  @override
  State<MyOrdesScreen> createState() => _MyOrdesScreenState();
}

class _MyOrdesScreenState extends State<MyOrdesScreen> {
  String selectedStatus = "All";
  List<Map<String, dynamic>> allOrders = []; // start empty
  bool isLoading = true; // for progress indicator

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final orders = await OrderService.getUserOrders();

    final processedOrders = orders.map((order) {
      final dateStr = order["orderDate"] ?? order["date"];
      String computedStatus = "Pending";

      if (dateStr != null && dateStr.isNotEmpty) {
        try {
          final orderDate = DateFormat('dd MMM, yyyy').parse(dateStr);
          final now = DateTime.now();

          // If today >= orderDate + 5 days → Delivered
          // If today >= orderDate + 4 days → Shipped
          // Otherwise → Pending
          if (now.isAfter(orderDate.add(const Duration(days: 5))) ||
              now.isAtSameMomentAs(orderDate.add(const Duration(days: 5)))) {
            computedStatus = "Delivered";
          } else if (now.isAfter(orderDate.add(const Duration(days: 4))) ||
              now.isAtSameMomentAs(orderDate.add(const Duration(days: 4)))) {
            computedStatus = "Shipped";
          } else {
            computedStatus = "Pending";
          }
        } catch (e) {
          computedStatus = "Pending";
        }
      }

      return {...order, "orderStatus": computedStatus};
    }).toList();

    setState(() {
      allOrders = processedOrders;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter orders based on selected status
    final filteredOrders = selectedStatus == "All"
        ? allOrders
        : allOrders
              .where((order) => order["orderStatus"] == selectedStatus)
              .toList();

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + 5),
                CustomAppBar(
                  title: "My Orders",
                  onBackPressed: () {
                    Navigator.pop(context);
                  },
                ),
                // 🔽 Top Slider Filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        TopSlider(
                          text: "All",
                          isSelected: selectedStatus == "All",
                          onTap: () => setState(() => selectedStatus = "All"),
                        ),
                        TopSlider(
                          text: "Delivered",
                          isSelected: selectedStatus == "Delivered",
                          onTap: () =>
                              setState(() => selectedStatus = "Delivered"),
                        ),
                        TopSlider(
                          text: "Shipped",
                          isSelected: selectedStatus == "Shipped",
                          onTap: () =>
                              setState(() => selectedStatus = "Shipped"),
                        ),
                        TopSlider(
                          text: "In Progress",
                          isSelected: selectedStatus == "Pending",
                          onTap: () =>
                              setState(() => selectedStatus = "Pending"),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // 🔽 Orders List
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: filteredOrders.isEmpty
                            ? [
                                Padding(
                                  padding: const EdgeInsets.only(top: 40),
                                  child: Center(
                                    child: Text(
                                      "None",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.mainText(
                                          context,
                                        ).withValues(alpha: 0.5),
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                            : filteredOrders.map((order) {
                                return OrderContainer(
                                  orderAmount:
                                      order["amount"]?.toString() ?? "0",
                                  orderDate: order["date"] ?? "",
                                  orderId: order["id"] ?? "",
                                  orderStatus:
                                      order["orderStatus"] ?? "Pending",
                                );
                              }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
    );
  }
}
