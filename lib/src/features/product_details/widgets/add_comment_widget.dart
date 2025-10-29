import 'package:decora/src/features/product_details/models/product_model.dart';
import 'package:decora/src/features/product_details/services/product_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/app_size.dart';
import '../../../shared/theme/app_colors.dart';
import 'package:intl/intl.dart';

class AddCommentWidget extends StatefulWidget {
  const AddCommentWidget({
    super.key,
    required this.productId,
    required this.onCommentAdded,
  });

  final String productId;
  final Function(Comment) onCommentAdded; // ✅ callback لما نضيف كومنت جديد

  @override
  State<AddCommentWidget> createState() => _AddCommentWidgetState();
}

class _AddCommentWidgetState extends State<AddCommentWidget> {
  final TextEditingController reviewController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final w = AppSize.width(context);
    final h = AppSize.height(context);
    final isLandscape = w > h;
    final iconSize = isLandscape ? w * 0.025 : 24.0;
    final containerHeight = isLandscape ? w * 0.06 : 40.0;
    final verticalPadding = isLandscape ? w * 0.005 : 5.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: containerHeight,
              decoration: BoxDecoration(
                color: AppColors.cardColor(),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Center(
                child: TextField(
                  controller: reviewController,
                  decoration: InputDecoration(
                    hintText: 'Write Your Review...',
                    hintStyle: TextStyle(
                      color: AppColors.secondaryText(),
                      fontSize: isLandscape ? w * 0.018 : 16,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: -verticalPadding,
                    ),
                  ),
                  style: TextStyle(color: AppColors.mainText()),
                ),
              ),
            ),
          ),
          SizedBox(width: w * 0.03),
          IconButton(
            icon: isLoading
                ? const CircularProgressIndicator()
                : Icon(
                    Icons.send,
                    color: AppColors.secondaryText(),
                    size: iconSize,
                  ),
            onPressed: isLoading
                ? null
                : () async {
                    final text = reviewController.text.trim();
                    if (text.isEmpty) return;

                    setState(() => isLoading = true);

                    final newComment = Comment(
                      text: text,
                      date: DateFormat('dd/MM/yyyy').format(DateTime.now()),
                      userid: FirebaseAuth.instance.currentUser!.uid,
                    );

                    await ProductService().addComment(
                      comment: newComment,
                      productId: widget.productId,
                    );

                    // ✅ نرجع الكومنت للأب
                    widget.onCommentAdded(newComment);

                    // مسح الكتابة
                    reviewController.clear();
                    setState(() => isLoading = false);
                  },
          ),
        ],
      ),
    );
  }
}
