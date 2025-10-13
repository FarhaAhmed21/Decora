import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({super.key, required this.text, required this.isSender});

  final String text;
  final bool isSender;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isSender
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isSender) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/sender_img.png',
                width: 30,
                height: 30,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
          ],

          Flexible(
            child: Container(
              padding: const  EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.cardColor(),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isSender ? 12 : 0),
                  topRight: Radius.circular(isSender ? 0 : 12),
                  bottomLeft: const Radius.circular(12),
                  bottomRight: const Radius.circular(12),
                ),
              ),
              child: Text(
                text,
                style:  TextStyle(fontSize: 14, color: AppColors.mainText()),
              ),
            ),
          ),

          if (isSender) ...[
            const SizedBox(width: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/receiver_img.jpg',
                width: 30,
                height: 30,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
