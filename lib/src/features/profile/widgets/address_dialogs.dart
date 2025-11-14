import 'package:decora/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:decora/src/features/Auth/models/address_model.dart';

Future<AddressModel?> showAddAddressDialog(BuildContext context) async {
  final cityController = TextEditingController();
  final streetController = TextEditingController();
  final buildingController = TextEditingController();

  return showDialog<AddressModel>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.add_new_address),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: cityController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.city,
            ),
          ),
          TextField(
            controller: streetController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.street,
            ),
          ),
          TextField(
            controller: buildingController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.building,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            if (cityController.text.isEmpty ||
                streetController.text.isEmpty ||
                buildingController.text.isEmpty) {
              return;
            }
            final address = AddressModel(
              id: const Uuid().v4(),
              city: cityController.text,
              street: streetController.text,
              building: buildingController.text,
              isDefault: false,
            );
            Navigator.pop(context, address);
          },
          child: Text(AppLocalizations.of(context)!.add),
        ),
      ],
    ),
  );
}

Future<AddressModel?> showEditAddressDialog(
  BuildContext context,
  AddressModel address,
) async {
  final cityController = TextEditingController(text: address.city);
  final streetController = TextEditingController(text: address.street);
  final buildingController = TextEditingController(text: address.building);

  return showDialog<AddressModel>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Edit Address"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: cityController,
            decoration: const InputDecoration(labelText: "City"),
          ),
          TextField(
            controller: streetController,
            decoration: const InputDecoration(labelText: "Street"),
          ),
          TextField(
            controller: buildingController,
            decoration: const InputDecoration(labelText: "Building"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            final updated = AddressModel(
              id: address.id,
              city: cityController.text,
              street: streetController.text,
              building: buildingController.text,
              isDefault: address.isDefault,
            );
            Navigator.pop(context, updated);
          },
          child: const Text("Save"),
        ),
      ],
    ),
  );
}
