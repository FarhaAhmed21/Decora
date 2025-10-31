import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decora/src/features/admin/screens/adminpanel.dart';
import 'package:decora/src/features/admin/widgets/custom_tile.dart';
import 'package:decora/src/shared/components/appbar.dart';
import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../product_details/models/product_model.dart';
import 'edit_product_screen.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key});

  Future<List<Product>> _fetchProducts() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .get();
    return snapshot.docs
        .map((doc) => Product.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> _deleteProduct(BuildContext context, String id) async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Product deleted successfully'),
          backgroundColor: AppColors.primary(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToEdit(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditProductScreen(product: product)),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Product product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this product?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _deleteProduct(context, product.id);
    }
  }

  Widget _buildProductTile(BuildContext context, Product product) {
    return ProductTailTile(
      product: product,
      onTap: () => _navigateToEdit(context, product),
      onEdit: () => _navigateToEdit(context, product),
      onDelete: () => _confirmDelete(context, product),
    );
  }

  Widget _buildProductList(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: _fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Expanded(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Expanded(
            child: Center(
              child: Text(
                'Error loading products',
                style: TextStyle(color: AppColors.mainText()),
              ),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Expanded(
            child: Center(
              child: Text(
                'No products found',
                style: TextStyle(color: AppColors.mainText()),
              ),
            ),
          );
        }

        final products = snapshot.data!;
        return Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              return _buildProductTile(context, products[index]);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: "All Products",
              onBackPressed: () {
                Navigator.pushReplacement(
                  context,
<<<<<<< HEAD
                  MaterialPageRoute(builder: (context) => const AdminPanel()),
=======
                  MaterialPageRoute(builder: (context) => AdminPanel()),
>>>>>>> 6501531305f0496f2e820dc8f30002dfcbfcf95f
                );
              },
            ),
            _buildProductList(context),
          ],
        ),
      ),
    );
  }
}
