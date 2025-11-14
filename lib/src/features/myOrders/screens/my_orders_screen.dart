import 'package:decora/src/features/myOrders/widgets/order_container.dart';
import 'package:decora/src/features/myOrders/widgets/top_slider.dart';
import 'package:decora/src/shared/components/appbar.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class MyOrdesScreen extends StatefulWidget {
  const MyOrdesScreen({super.key});

  @override
  State<MyOrdesScreen> createState() => _MyOrdesScreenState();
}

class _MyOrdesScreenState extends State<MyOrdesScreen> {
  String selectedStatus = "All";

  final List<Map<String, String>> allOrders = [
    {
      "orderAmount": "2000",
      "orderDate": "14 Jun, 2025",
      "orderId": "12345",
      "orderStatus": "Shipped",
    },
    {
      "orderAmount": "260",
      "orderDate": "14 Jun, 2025",
      "orderId": "12345",
      "orderStatus": "Shipped",
    },
    {
      "orderAmount": "100",
      "orderDate": "14 Jun, 2025",
      "orderId": "12345",
      "orderStatus": "Shipped",
    },
    {
      "orderAmount": "1000",
      "orderDate": "19 Jun, 2025",
      "orderId": "12346",
      "orderStatus": "Pending",
    },
    {
      "orderAmount": "560",
      "orderDate": "20 Jun, 2025",
      "orderId": "12347",
      "orderStatus": "Delivered",
    },
    {
      "orderAmount": "320",
      "orderDate": "25 Jun, 2025",
      "orderId": "12348",
      "orderStatus": "Pending",
    },
    {
      "orderAmount": "3900",
      "orderDate": "5 Jun, 2025",
      "orderId": "12349",
      "orderStatus": "Shipped",
    },
  ];

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
      body: Column(
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
                    onTap: () => setState(() => selectedStatus = "Delivered"),
                  ),
                  TopSlider(
                    text: "Shipped",
                    isSelected: selectedStatus == "Shipped",
                    onTap: () => setState(() => selectedStatus = "Shipped"),
                  ),
                  TopSlider(
                    text: "In Progress",
                    isSelected: selectedStatus == "Pending",
                    onTap: () => setState(() => selectedStatus = "Pending"),
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
                  children: filteredOrders.map((order) {
                    return OrderContainer(
                      orderAmount: order["orderAmount"]!,
                      orderDate: order["orderDate"]!,
                      orderId: order["orderId"]!,
                      orderStatus: order["orderStatus"]!,
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
