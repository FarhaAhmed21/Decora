import 'dart:io';
import 'package:decora/src/features/product_details/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../shared/theme/app_colors.dart';
import '../../profile/service/upload_image.dart';

Future<void> showAddColorDialog(
  BuildContext context,
  Function(ProductColor) onColorAdded,
) async {
  final colorNameController = TextEditingController();
  final hexColorController = TextEditingController();
  File? colorImage;
  bool isUploading = false;

  await showDialog(
    context: context,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.background(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              "Add Product Color",
              style: TextStyle(color: AppColors.mainText(context)),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    style: TextStyle(color: AppColors.mainText(context)),
                    controller: colorNameController,
                    decoration: InputDecoration(
                      labelText: 'Color Name',
                      labelStyle: TextStyle(color: AppColors.mainText(context)),
                    ),
                  ),
                  TextField(
                    style: TextStyle(color: AppColors.mainText(context)),
                    controller: hexColorController,
                    decoration: InputDecoration(
                      labelText: 'Hex Color',
                      labelStyle: TextStyle(color: AppColors.mainText(context)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final source = await showDialog<ImageSource>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Choose Image Source"),
                          actions: [
                            TextButton.icon(
                              icon: const Icon(Icons.camera_alt),
                              label: const Text("Camera"),
                              onPressed: () =>
                                  Navigator.pop(context, ImageSource.camera),
                            ),
                            TextButton.icon(
                              icon: const Icon(Icons.photo),
                              label: const Text("Gallery"),
                              onPressed: () =>
                                  Navigator.pop(context, ImageSource.gallery),
                            ),
                          ],
                        ),
                      );
                      if (source == null) return;
                      final picked = await picker.pickImage(
                        source: source,
                        imageQuality: 80,
                      );
                      if (picked != null) {
                        setDialogState(() => colorImage = File(picked.path));
                      }
                    },
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.cardColor(context),
                        borderRadius: BorderRadius.circular(12),
                        image: colorImage != null
                            ? DecorationImage(
                                image: FileImage(colorImage!),
                                fit: BoxFit.cover,
                              )
                            : null,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: colorImage == null
                          ? const Center(
                              child: Icon(
                                Icons.add_a_photo_outlined,
                                size: 40,
                                color: Colors.grey,
                              ),
                            )
                          : null,
                    ),
                  ),
                  if (isUploading)
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    AppColors.cardColor(context),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: AppColors.mainText(context)),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (colorNameController.text.isEmpty ||
                      hexColorController.text.isEmpty ||
                      colorImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please fill all fields and pick an image',
                        ),
                      ),
                    );
                    return;
                  }

                  setDialogState(() => isUploading = true);
                  final url = await ImageUploader.uploadToImgBB(colorImage!);
                  setDialogState(() => isUploading = false);

                  if (url != null) {
                    onColorAdded(
                      ProductColor(
                        colorName: colorNameController.text,
                        hexColor: hexColorController.text,
                        imageUrl: url,
                      ),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to upload color image'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary(context),
                ),
                child: Text(
                  "Add",
                  style: TextStyle(color: AppColors.mainText(context)),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
