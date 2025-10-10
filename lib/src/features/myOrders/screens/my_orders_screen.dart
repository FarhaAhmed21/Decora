// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:decora/src/features/myOrders/widgets/order_container.dart';
import 'package:decora/src/features/myOrders/widgets/top_slider.dart';
import 'package:decora/src/shared/components/appbar.dart';
import 'package:flutter/material.dart';

class MyOrdesScreen extends StatelessWidget {
  const MyOrdesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "My Orders"),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  TopSlider(text: "All", isSelected: true),
                  TopSlider(text: "Delivered"),
                  TopSlider(text: "Shipping"),
                  TopSlider(text: "In Progress"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [for (int i = 0; i < 7; i++) OrderContainer()],
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
