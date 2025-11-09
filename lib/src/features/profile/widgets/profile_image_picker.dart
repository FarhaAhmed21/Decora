import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:decora/src/shared/theme/app_colors.dart';

class ProfileImagePicker extends StatefulWidget {
  final ImageProvider imageProvider;
  final Function(File?) onPick;

  const ProfileImagePicker({
    super.key,
    required this.imageProvider,
    required this.onPick,
  });

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  final ImagePicker _picker = ImagePicker();

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(
              Icons.photo_camera,
              color: AppColors.primary(context),
            ),
            title: Text(
              "Take a Photo",
              style: TextStyle(color: AppColors.mainText(context)),
            ),
            onTap: () => _pickImage(ImageSource.camera),
          ),
          ListTile(
            leading: Icon(
              Icons.photo_library,
              color: AppColors.primary(context),
            ),
            title: Text(
              "Choose from Gallery",
              style: TextStyle(color: AppColors.mainText(context)),
            ),
            onTap: () => _pickImage(ImageSource.gallery),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 75);
    if (picked != null) {
      widget.onPick(File(picked.path));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          backgroundColor: AppColors.primary(context),
          radius: 73,
          child: CircleAvatar(
            radius: 70,
            backgroundImage: widget.imageProvider,
          ),
        ),
        Container(
          width: 44,
          height: 44,
          margin: const EdgeInsets.only(bottom: 3, right: 6),
          decoration: BoxDecoration(
            color: AppColors.primary(context),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: _showOptions,
          ),
        ),
      ],
    );
  }
}
