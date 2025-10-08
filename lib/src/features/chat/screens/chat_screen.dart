import 'package:decora/generated/assets.dart';
import 'package:decora/src/features/chat/widgets/date_widget.dart';
import 'package:decora/src/features/chat/widgets/message_widget.dart';
import 'package:decora/src/shared/components/appbar.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      appBar: const CustomAppBar(title: "Admin"),
      backgroundColor: AppColors.background,
      body: SafeArea(
        
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const DateWidget(date: "Yesterday"),
                  const MessageWidget(text: "Hi, Decora", isSender: true),
                  const MessageWidget(text: "Hi, Decora", isSender: false),
                  const MessageWidget(
                    text:
                        "Hi, Decora , Hi, DecoraHi, DecoraHi, DecoraHi, Decora",
                    isSender: false,
                  ),
                  SizedBox(height: height * 0.01),
                  const DateWidget(date: "Today"),
                  const MessageWidget(text: "Hi, Decora", isSender: true),
                  const MessageWidget(text: "Hi, Decora", isSender: false),
                  const MessageWidget(text: "Hi, Decora", isSender: false),
                  const MessageWidget(text: "Hi, Decora", isSender: false),
                  const MessageWidget(
                    text:
                        "Hi, Decora , Hi, DecoraHi, DecoraHi, DecoraHi, Decora",
                    isSender: false,
                  ),
                  const MessageWidget(
                    text:
                        "Hi, Decora , Hi, DecoraHi, DecoraHi, DecoraHi, Decora",
                    isSender: false,
                  ),
                  const MessageWidget(
                    text:
                        "Hi, Decora , Hi, DecoraHi, DecoraHi, DecoraHi, Decora",
                    isSender: false,
                  ),
                  const MessageWidget(
                    text:
                        "Hi, Decora , Hi, DecoraHi, DecoraHi, DecoraHi, Decora",
                    isSender: false,
                  ),
                  const MessageWidget(
                    text:
                        "Hi, Decora , Hi, DecoraHi, DecoraHi, DecoraHi, Decora",
                    isSender: false,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardColor, width: 2.0),
                ),
                child: Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(width * 0.02),
                        decoration: BoxDecoration(
                          color: AppColors.cardColor,
                          borderRadius: BorderRadius.circular(width * 0.06),
                        ),
                        child: Image.asset(
                          Assets.micIcon,
                          color: AppColors.primary,
                          width: width * 0.05,
                          height: width * 0.05,
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.015),
                    InkWell(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(width * 0.02),
                        decoration: BoxDecoration(
                          color: AppColors.cardColor,
                          borderRadius: BorderRadius.circular(width * 0.06),
                        ),
                        child: Image.asset(
                          Assets.plusIcon,
                          color: AppColors.primary,
                          width: width * 0.05,
                          height: width * 0.05,
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.015),
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Type Something..",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: AppColors.secondaryText),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(width * 0.04),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset(
                          Assets.sentIcon,
                          color: AppColors.background,
                          width: width * 0.05,
                          height: width * 0.05,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
