import 'package:decora/core/utils/app_size.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final h = AppSize.height(context);
    final w = AppSize.width(context);

    return Container(
      height: h * 0.076,
      color: Colors.white,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: w * 0.055),
            child: InkWell(
              borderRadius: BorderRadius.circular(w * 0.012),
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(w * 0.025),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(w * 0.02),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                  size: w * 0.045,
                ),
              ),
            ),
          ),

          Expanded(
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: w * 0.05,
                ),
              ),
            ),
          ),
          SizedBox(width: w * 0.09),
        ],
      ),
    );
  }
}
