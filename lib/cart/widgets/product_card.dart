import 'package:decora/core/util/app_font.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
          color: Color(0xFFF6F6F6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[400],
                    child: const Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + Rating
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Moss Accent Sofa",
                              style: AppFont.fontStyle(
                                fontWeight: FontWeight.w400,
                                fontsize: 16,
                                color: Colors.black,
                              ),

                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(
                            Icons.star,
                            size: 18,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "4.9",
                            style: AppFont.fontStyle(
                              fontWeight: FontWeight.w400,
                              fontsize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Categories
                      Wrap(
                        spacing: 6,
                        children: [
                          _buildTag("Dining"),
                          _buildTag("Furniture"),
                          _buildTag("Wood"),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Price + Quantity Controls
                      Row(
                        children: [
                          Text(
                            "\$240",
                            style: AppFont.fontStyle(
                              fontWeight: FontWeight.w400,
                              fontsize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const Spacer(),

                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.remove),
                                  iconSize: 18,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "1",
                                style: AppFont.fontStyle(
                                  fontWeight: FontWeight.w500,
                                  fontsize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color(0xFF446F4D),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  iconSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppFont.fontStyle(
          fontWeight: FontWeight.w400,
          fontsize: 12,
          color: Colors.green,
        ),
      ),
    );
  }
}
