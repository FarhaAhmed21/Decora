import 'dart:io';
import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/src/features/profile/widgets/address_list_section.dart';
import 'package:decora/src/features/profile/widgets/profile_image_picker.dart';
import 'package:decora/src/features/profile/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:decora/src/shared/components/appbar.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:decora/src/features/Auth/models/user_model.dart';
import 'package:decora/src/features/Auth/models/address_model.dart';
import '../service/savechanges.dart';

class EditProfileUI extends StatefulWidget {
  final UserModel user;

  const EditProfileUI({super.key, required this.user});

  @override
  State<EditProfileUI> createState() => _EditProfileUIState();
}

class _EditProfileUIState extends State<EditProfileUI> {
  File? _imageFile;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  List<AddressModel> addresses = [];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name ?? '');
    emailController = TextEditingController(text: widget.user.email ?? '');
    phoneController = TextEditingController(text: widget.user.phone ?? '');
    addresses = List<AddressModel>.from(widget.user.addresses ?? []);
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = _imageFile != null
        ? FileImage(_imageFile!)
        : (widget.user.photoUrl!.startsWith('http')
                  ? NetworkImage(widget.user.photoUrl!)
                  : AssetImage(widget.user.photoUrl!))
              as ImageProvider;

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 5),
          CustomAppBar(
            title: AppLocalizations.of(context)!.edit_profile,
            onBackPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  ProfileImagePicker(
                    imageProvider: imageProvider,
                    onPick: (file) => setState(() => _imageFile = file),
                    parentContext: context,
                  ),

                  const SizedBox(height: 20),

                  TextFieldWidget(
                    label: AppLocalizations.of(context)!.name,
                    controller: nameController,
                    hint: AppLocalizations.of(context)!.name,
                  ),
                  TextFieldWidget(
                    label: AppLocalizations.of(context)!.phone_number,
                    controller: phoneController,
                    hint: AppLocalizations.of(context)!.phone_number,
                  ),

                  const SizedBox(height: 20),

                  AddressListSection(
                    addresses: addresses,
                    onChanged: (newList) {
                      setState(() => addresses = newList);
                    },
                  ),

                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          widget.user
                            ..name = nameController.text
                            ..phone = phoneController.text
                            ..addresses = List<AddressModel>.from(addresses);
                        });

                        final updatedUser = widget.user;

                        await Savechanges().savechange(updatedUser, _imageFile);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Profile updated successfully!"),
                          ),
                        );

                        Navigator.pop(context, updatedUser);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.save_changes,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
