import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decora/src/features/admin/widgets/color_dialog.dart';
import 'package:decora/src/features/admin/widgets/product_field.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../shared/components/appbar.dart';
import '../../product_details/models/product_model.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _extraInfoController = TextEditingController();
  final _detailsController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  final _quantityController = TextEditingController();
  final _categoryController = TextEditingController();

  bool _isNewCollection = false;
  bool _isLoading = false;
  final List<ProductColor> _colors = [];

  Future<void> _addProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_colors.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one color')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final docRef = FirebaseFirestore.instance.collection('products').doc();

      final product = Product(
        id: docRef.id,
        name: _nameController.text,
        extraInfo: _extraInfoController.text,
        details: _detailsController.text,
        price: double.parse(_priceController.text),
        discount: int.tryParse(_discountController.text) ?? 0,
        quantity: int.tryParse(_quantityController.text) ?? 0,
        isNewCollection: _isNewCollection,
        category: _categoryController.text,
        colors: _colors,
        comments: [],
      );

      await docRef.set({...product.toMap(), 'id': product.id});

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully!')),
      );
      _formKey.currentState!.reset();
      setState(() => _colors.clear());
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background(),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: 'Add Product',
              onBackPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.05,
                  vertical: 12,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductField(
                        controller: _nameController,
                        label: 'Name',
                        validator: true,
                      ),
                      ProductField(
                        controller: _extraInfoController,
                        label: 'Extra Info',
                      ),
                      ProductField(
                        controller: _detailsController,
                        label: 'Details',
                        lines: 3,
                      ),
                      ProductField(
                        controller: _priceController,
                        label: 'Price',
                        type: TextInputType.number,
                        validator: true,
                      ),
                      ProductField(
                        controller: _discountController,
                        label: 'Discount',
                        type: TextInputType.number,
                      ),
                      ProductField(
                        controller: _quantityController,
                        label: 'Quantity',
                        type: TextInputType.number,
                      ),
                      ProductField(
                        controller: _categoryController,
                        label: 'Category',
                      ),
                      SwitchListTile(
                        title: Text(
                          'New Collection',
                          style: TextStyle(color: AppColors.mainText()),
                        ),
                        value: _isNewCollection,
                        onChanged: (val) =>
                            setState(() => _isNewCollection = val),
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Colors',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.mainText(),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => showAddColorDialog(
                              context,
                              (newColor) =>
                                  setState(() => _colors.add(newColor)),
                            ),
                            icon: Icon(Icons.add, color: AppColors.mainText()),
                            label: Text(
                              'Add Color',
                              style: TextStyle(color: AppColors.mainText()),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (_colors.isNotEmpty)
                        ..._colors.map(
                          (c) => Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: c.color,
                                radius: 16,
                              ),
                              title: Text(c.colorName),
                              subtitle: Text(c.hexColor),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () =>
                                    setState(() => _colors.remove(c)),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _addProduct,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary(),
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Add Product',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.mainText(),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
