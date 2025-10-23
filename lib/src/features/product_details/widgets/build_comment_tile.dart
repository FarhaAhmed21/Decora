import 'package:flutter/material.dart';

import '../../../shared/theme/app_colors.dart';
import '../models/product_model.dart';


Widget BuildCommentTile(Comment comment) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      vertical: 4.0,
    ), // Outer padding for separation
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(comment.profilePic),
            ),
            const SizedBox(width: 8),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(
                  12.0,
                ), // Padding inside the gray box
                decoration: BoxDecoration(
                  color: AppColors.cardColor(),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            comment.text,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.mainText(),
                            ),
                          ),
                        ),

                        Text(
                          comment.date,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.secondaryText(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    Text(
                      comment.text,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.secondaryText(),
                      ),
                    ),

                    if (comment.profilePic.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          height: 80, // Height for the horizontal image list
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: comment.profilePic.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    comment.profilePic[index],
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
