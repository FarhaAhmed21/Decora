import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../shared/theme/app_colors.dart';
import '../../product_details/models/product_model.dart';
import '../../profile/service/upload_image.dart';

Future<void> showEditColorDialog(
  BuildContext context,
  ProductColor color,
  Function(ProductColor) onColorEdited,
) async {
  final colorNameController = TextEditingController(text: color.colorName);
  final hexColorController = TextEditingController(text: color.hexColor);
  File? newImageFile;
  bool isUploading = false;
  String imageUrl = color.imageUrl;

  await showDialog(
    context: context,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.background(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              "Edit Color",
              style: TextStyle(color: AppColors.mainText()),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    style: TextStyle(color: AppColors.mainText()),
                    controller: colorNameController,
                    decoration: InputDecoration(
                      labelText: 'Color Name',
                      labelStyle: TextStyle(color: AppColors.mainText()),
                    ),
                  ),
                  TextField(
                    style: TextStyle(color: AppColors.mainText()),
                    controller: hexColorController,
                    decoration: InputDecoration(
                      labelText: 'Hex Color',
                      labelStyle: TextStyle(color: AppColors.mainText()),
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
                        setDialogState(() => newImageFile = File(picked.path));
                      }
                    },
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.cardColor(),
                        borderRadius: BorderRadius.circular(12),
                        image: newImageFile != null
                            ? DecorationImage(
                                image: FileImage(newImageFile!),
                                fit: BoxFit.cover,
                              )
                            : DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover,
                              ),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: newImageFile == null && imageUrl.isEmpty
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
                  backgroundColor: MaterialStateProperty.all(
                    AppColors.cardColor(),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: AppColors.mainText()),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (colorNameController.text.isEmpty ||
                      hexColorController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields')),
                    );
                    return;
                  }

                  if (newImageFile != null) {
                    setDialogState(() => isUploading = true);
                    final uploadedUrl = await ImageUploader.uploadToImgBB(
                      newImageFile!,
                    );
                    setDialogState(() => isUploading = false);
                    if (uploadedUrl != null) {
                      imageUrl = uploadedUrl;
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to upload new image'),
                        ),
                      );
                      return;
                    }
                  }

                  onColorEdited(
                    ProductColor(
                      colorName: colorNameController.text,
                      hexColor: hexColorController.text,
                      imageUrl: imageUrl,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary(),
                ),
                child: Text(
                  "Save",
                  style: TextStyle(color: AppColors.mainText()),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
