import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/widgets.dart';

class NotificationsText extends StatelessWidget {
  final String text;
  const NotificationsText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.bold,
        color: AppColors.mainText(),
      ),
    );
  }
}
