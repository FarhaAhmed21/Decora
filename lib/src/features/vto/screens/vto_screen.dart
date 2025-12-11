import 'dart:io';

import 'package:decora/src/features/product_details/models/product_model.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

import '../../../../core/utils/app_size.dart';
import '../../../../generated/assets.dart';

// --- Placeholder for the Furniture Model (The Orange Chair) ---
// Since we don't have the exact 3D model, we'll use a local asset or a placeholder.
// For this example, let's assume you've added an asset for the orange chair.
// const String _kChairAssetName = 'assets/images/chair_placeholder.png';
// NOTE: Make sure to replace 'assets/images/office.png'
// in furnitureImages with a list of actual furniture image assets,
// and add the orange chair asset.

class VtoScreen extends StatefulWidget {
  final List<Product> products;
  const VtoScreen({super.key, required this.products});

  @override
  _VtoScreenState createState() => _VtoScreenState();
}

class _VtoScreenState extends State<VtoScreen> {
  XFile? _pickedImage;
  CameraController? _cameraController;
  bool _isLive = true; // Start with live camera on as a common VTO pattern
  late String _selectedFurniture;
  final List<String> images = [];

  @override
  void initState() {
    super.initState();
    _initCamera();
    for (var product in widget.products) {
      for (var color in product.colors) {
        images.add(color.imageUrl);
      }
    }
    _selectedFurniture = images.first;
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.medium,
      );
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    // Changed source to gallery to allow selecting a room image easily.
    if (picked != null) {
      setState(() {
        _pickedImage = picked;
        _isLive = false;
      });
    }
  }

  void _toggleLiveCamera() {
    setState(() {
      _isLive = !_isLive;
    });
  }

  // --- Widget Builders for UI Components ---

  // Renders the background, either live camera, picked image, or a placeholder
  Widget _buildBackground() {
    if (_isLive) {
      return (_cameraController != null &&
              _cameraController!.value.isInitialized
          ? CameraPreview(_cameraController!)
          : const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ));
    } else if (_pickedImage != null) {
      return Image.file(File(_pickedImage!.path), fit: BoxFit.cover);
    } else {
      // Placeholder background for the room aesthetic
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          // image: DecorationImage(
          //   image: AssetImage('assets/images/room_placeholder.jpg'),
          //   fit: BoxFit.cover,
          // ),
        ),
      );
    }
  }

  // Renders the virtual furniture in the center with controls
  Widget _buildVtoView(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double boxSize = size.width * 0.7;

    return InteractiveViewer(
      panEnabled: true,
      scaleEnabled: true,
      minScale: 0.5,
      maxScale: double.infinity,
      boundaryMargin: const EdgeInsets.all(double.infinity),
      child: Center(
        child: Container(
          width: boxSize,
          height: boxSize,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 2.0),
          ),
          child: Stack(
            children: [
              CustomPaint(
                size: Size(boxSize, boxSize),
                painter: DashedRectPainter(
                  color: Colors.blue.withOpacity(0.8),
                  strokeWidth: 2.0,
                  gap: 5.0,
                ),
              ),
              Center(
                child: Image.network(_selectedFurniture, fit: BoxFit.fill),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text(
                      '< 360 >',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Renders the vertical scroll list of furniture on the right
  Widget _buildFurnitureList() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0, top: 50, bottom: 50),
        child: SizedBox(
          width: 60,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: images.length,
            itemBuilder: (context, index) {
              final item = images[index];
              final isSelected = item == _selectedFurniture;
              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFurniture = item;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                      boxShadow: isSelected
                          ? [
                              const BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5,
                              ),
                            ]
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Renders the custom bottom controls (Camera, Gallery, Big Shutter)
  Widget _buildBottomControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: AppSize.height(context) * 0.2,
        color: AppColors.background(context), // Dark background for contrast
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Video / Toggle Live
            GestureDetector(
              onTap: _toggleLiveCamera,
              child: Image.asset(
                Assets.videoIcon,
                color: AppColors.mainText(context),
              ),
            ),
            // Main Shutter Button
            GestureDetector(
              onTap: () async {
                try {
                  if (_isLive &&
                      _cameraController != null &&
                      _cameraController!.value.isInitialized) {
                    final image = await _cameraController!.takePicture();
                    setState(() {
                      _pickedImage = image;
                      _isLive = false; // Switch to display mode
                    });
                  } else {
                    // If using a gallery or background image, you can later implement
                    // saving a screenshot using RepaintBoundary
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Live camera is off. Turn it on to capture!',
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  print('Error taking picture: $e');
                }
              },

              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.shoppingIconColor(context),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.primary(
                        context,
                      ), // Green center like in the image
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            // Gallery / Pick Image
            GestureDetector(
              onTap: _pickImage,
              child: Image.asset(
                Assets.imageIcon,
                color: AppColors.mainText(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The background color is black to match the outer frame of the screenshot
      backgroundColor: Colors.black,
      body: SafeArea(
        // The main content area is the inner screen part
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20), // Rounded screen corners
          child: Stack(
            children: [
              // 1. Background (Camera/Image/Placeholder)
              Positioned.fill(child: _buildBackground()),

              // 2. Virtual Try-On (VTO) View with the chair and blue box
              _buildVtoView(context),

              // 3. Furniture Selection List
              _buildFurnitureList(),

              // 6. Bottom Controls (Camera/Gallery/Shutter)
              _buildBottomControls(),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Helper class to draw the dashed border ---
class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();

    // The rect boundary
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Draw the dashed lines (simplified, can be more complex for perfect corners)
    double distance = 0.0;
    while (distance < rect.width) {
      path.moveTo(rect.left + distance, rect.top);
      distance += gap;
      path.lineTo(rect.left + distance.clamp(0.0, rect.width), rect.top);
      distance += gap;
    }

    distance = 0.0;
    while (distance < rect.height) {
      path.moveTo(rect.right, rect.top + distance);
      distance += gap;
      path.lineTo(rect.right, rect.top + distance.clamp(0.0, rect.height));
      distance += gap;
    }

    distance = 0.0;
    while (distance < rect.width) {
      path.moveTo(rect.right - distance, rect.bottom);
      distance += gap;
      path.lineTo(rect.right - distance.clamp(0.0, rect.width), rect.bottom);
      distance += gap;
    }

    distance = 0.0;
    while (distance < rect.height) {
      path.moveTo(rect.left, rect.bottom - distance);
      distance += gap;
      path.lineTo(rect.left, rect.bottom - distance.clamp(0.0, rect.height));
      distance += gap;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
