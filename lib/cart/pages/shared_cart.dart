import 'package:decora/cart/widgets/product_card.dart';
import 'package:decora/core/util/app_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_overlap/flutter_image_overlap.dart';

class SharedCart extends StatelessWidget {
  const SharedCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 5.0, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Owners Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Text(
                    "Owners: ",
                    style: AppFont.fontStyle(
                      fontWeight: FontWeight.w500,
                      fontsize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 200,
                    child: OverlappingImages(
                      images: const [
                        NetworkImage(
                          'https://tse4.mm.bing.net/th/id/OIP.PVLm8FPquyPaETrn3OHvuwHaEK?cb=12',
                        ),
                        NetworkImage(
                          'https://tse2.mm.bing.net/th/id/OIP.Erb0ExAqXl5-gVYmqBv_uAHaE8',
                        ),
                        NetworkImage(
                          'https://cdn.pixabay.com/photo/2017/07/12/17/17/sunset-2497594_960_720.png',
                        ),
                      ],
                      imageRadius: 18.0,
                      overlapOffset: 20.0,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "View all",
                      style: AppFont.fontStyle(
                        fontWeight: FontWeight.w500,
                        fontsize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),


            // 🔹 Product List (inside scroll view)
            ListView.builder(
              itemCount: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return const ProductCard();
              },
            ),
          ],
        ),
      ),
    );
  }
}
