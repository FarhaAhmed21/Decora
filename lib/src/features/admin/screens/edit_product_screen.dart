import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decora/src/features/admin/screens/allprodects_screen.dart';
import 'package:decora/src/features/admin/widgets/color_dialog.dart';
import 'package:decora/src/features/admin/widgets/edit_color.dart';
import 'package:flutter/material.dart';
import '../../../shared/components/appbar.dart';
import '../../../shared/theme/app_colors.dart';
import '../../product_details/models/product_model.dart';

class EditProductScreen extends StatefulWidget {
  Product product;

  EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _extraInfoController;
  late TextEditingController _detailsController;
  late TextEditingController _priceController;
  late TextEditingController _discountController;
  late TextEditingController _quantityController;
  late TextEditingController _categoryController;

  bool _isNewCollection = false;
  bool _isLoading = false;
  late List<ProductColor> _colors;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _extraInfoController = TextEditingController(
      text: widget.product.extraInfo,
    );
    _detailsController = TextEditingController(text: widget.product.details);
    _priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
    _discountController = TextEditingController(
      text: widget.product.discount.toString(),
    );
    _quantityController = TextEditingController(
      text: widget.product.quantity.toString(),
    );
    _categoryController = TextEditingController(text: widget.product.category);
    _isNewCollection = widget.product.isNewCollection;
    _colors = List<ProductColor>.from(widget.product.colors);
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_colors.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one color')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final docRef = FirebaseFirestore.instance
          .collection('products')
          .doc(widget.product.id);

      final updatedProduct = Product(
        id: widget.product.id,
        name: _nameController.text,
        extraInfo: _extraInfoController.text,
        details: _detailsController.text,
        price: double.parse(_priceController.text),
        discount: int.tryParse(_discountController.text) ?? 0,
        quantity: int.tryParse(_quantityController.text) ?? 0,
        isNewCollection: _isNewCollection,
        category: _categoryController.text,
        colors: _colors,
        comments: widget.product.comments,
      );

      await docRef.update(updatedProduct.toMap());

      setState(() {
        widget.product = updatedProduct;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated successfully!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AllProductsScreen()),

      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating product: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: 'Edit Product',
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
                      _buildField('Name', _nameController, true),
                      _buildField('Extra Info', _extraInfoController),
                      _buildField('Details', _detailsController, false, 3),
                      _buildField(
                        'Price',
                        _priceController,
                        true,
                        1,
                        TextInputType.number,
                      ),
                      _buildField(
                        'Discount',
                        _discountController,
                        false,
                        1,
                        TextInputType.number,
                      ),
                      _buildField(
                        'Quantity',
                        _quantityController,
                        false,
                        1,
                        TextInputType.number,
                      ),
                      _buildField('Category', _categoryController),
                      SwitchListTile(
                        title: Text(
                          'New Collection',
                          style: TextStyle(color: AppColors.mainText(context)),
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
                              color: AppColors.mainText(context),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => showAddColorDialog(
                              context,
                              (newColor) =>
                                  setState(() => _colors.add(newColor)),
                            ),
                            icon: Icon(
                              Icons.add,
                              color: AppColors.mainText(context),
                            ),
                            label: Text(
                              'Add Color',
                              style: TextStyle(
                                color: AppColors.mainText(context),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary(context),
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
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () => showEditColorDialog(
                                      context,
                                      c,
                                      (editedColor) {
                                        setState(() {
                                          final index = _colors.indexOf(c);
                                          _colors[index] = editedColor;
                                        });
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () =>
                                        setState(() => _colors.remove(c)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _updateProduct,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary(context),
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
                                'Save Changes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.mainText(context),
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

  Widget _buildField(
    String label,
    TextEditingController controller, [
    bool validator = false,
    int lines = 1,
    TextInputType type = TextInputType.text,
  ]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        maxLines: lines,
        validator: validator
            ? (value) => value == null || value.isEmpty ? 'Required' : null
            : null,
        style: TextStyle(color: AppColors.mainText(context)),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: AppColors.mainText(context)),
          filled: true,
          fillColor: AppColors.cardColor(context),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
