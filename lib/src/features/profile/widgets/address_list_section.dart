import 'package:decora/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:decora/src/features/Auth/models/address_model.dart';
import 'address_dialogs.dart';

class AddressListSection extends StatefulWidget {
  final List<AddressModel> addresses;
  final Function(List<AddressModel>) onChanged;

  const AddressListSection({
    super.key,
    required this.addresses,
    required this.onChanged,
  });

  @override
  State<AddressListSection> createState() => _AddressListSectionState();
}

class _AddressListSectionState extends State<AddressListSection> {
  late List<AddressModel> _addresses;

  @override
  void initState() {
    super.initState();
    _addresses = List<AddressModel>.from(widget.addresses);
  }

  void _addAddress() async {
    final newAddress = await showAddAddressDialog(context);
    if (newAddress != null) {
      setState(() => _addresses.add(newAddress));
      widget.onChanged(_addresses);
    }
  }

  void _editAddress(AddressModel address) async {
    final updatedAddress = await showEditAddressDialog(context, address);
    if (updatedAddress != null) {
      setState(() {
        final index = _addresses.indexWhere((a) => a.id == address.id);
        if (index != -1) _addresses[index] = updatedAddress;
      });
      widget.onChanged(_addresses);
    }
  }

  void _deleteAddress(AddressModel address) {
    setState(() {
      _addresses.removeWhere((a) => a.id == address.id);
      widget.onChanged(_addresses);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // العنوان + زر الإضافة
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.addresses,
              style: TextStyle(
                color: AppColors.mainText(context),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            IconButton(
              onPressed: _addAddress,
              icon: Icon(
                Icons.add_location_alt,
                color: AppColors.primary(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // القائمة
        if (_addresses.isEmpty)
          Text(
            AppLocalizations.of(context)!.no_addresses,
            style: TextStyle(color: AppColors.secondaryText(context)),
          )
        else
          Column(
            children: _addresses.map((addr) {
              return Card(
                color: AppColors.cardColor(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    "${addr.city}, ${addr.street}",
                    style: TextStyle(color: AppColors.mainText(context)),
                  ),
                  subtitle: Text(
                    "Building: ${addr.building}",
                    style: TextStyle(color: AppColors.secondaryText(context)),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editAddress(addr),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteAddress(addr),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
