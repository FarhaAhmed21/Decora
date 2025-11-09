import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

void showFilterBottomSheet({
  required BuildContext context,
  required double minPrice,
  required double maxPrice,
  required Function(double, double) onApply,
}) {
  double tempMin = minPrice;
  double tempMax = maxPrice;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.cardColor(context),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(25),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Filter by Price",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.mainText(context),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Divider(color: Colors.grey.withOpacity(0.3), thickness: 1),
                const SizedBox(height: 20),
                Text(
                  "Price Range: \$${tempMin.round()} - \$${tempMax.round()}",
                  style: TextStyle(
                    color: AppColors.secondaryText(context),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),
                RangeSlider(
                  values: RangeValues(tempMin, tempMax),
                  min: 0,
                  max: 2000,
                  divisions: 40,
                  activeColor: AppColors.primary(context),
                  inactiveColor: Colors.grey[300],
                  labels: RangeLabels(
                    "\$${tempMin.round()}",
                    "\$${tempMax.round()}",
                  ),
                  onChanged: (values) {
                    setModalState(() {
                      tempMin = values.start;
                      tempMax = values.end;
                    });
                  },
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setModalState(() {
                            tempMin = 0;
                            tempMax = 2000;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.primary(context)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          "Reset",
                          style: TextStyle(
                            color: AppColors.primary(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onApply(tempMin, tempMax);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary(context),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          "Apply",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.mainText(context),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
