import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/core/utils/app_size.dart';
import 'package:decora/src/features/cart/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_overlap/flutter_image_overlap.dart';

class SharedCart extends StatefulWidget {
  const SharedCart({super.key});

  @override
  State<SharedCart> createState() => _SharedCartState();
}

class _SharedCartState extends State<SharedCart>
    with SingleTickerProviderStateMixin {
  bool _isVisible = false;
  TabController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final controller = DefaultTabController.of(context);
    if (_controller != controller) {
      _controller?.removeListener(_handleTabChange);
      _controller = controller;
      _controller?.addListener(_handleTabChange);
    }
  }

  void _handleTabChange() {
    if (!mounted || _controller == null) return;


    if (!_controller!.indexIsChanging) {
      setState(() {
        _isVisible = _controller!.index == 1;
      });
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_handleTabChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 5.0, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Owners Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  // Slide owners row in/out
                  AnimatedSlide(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    offset: _isVisible ? Offset.zero : const Offset(-1.5, 0),
                    child: Row(
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.owners}: ",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: AppSize.width(context) * 0.3,
                          child: const OverlappingImages(
                            images: [
                              NetworkImage(
                                'https://tse4.mm.bing.net/th/id/OIP.PVLm8FPquyPaETrn3OHvuwHaEK?cb=12',
                              ),
                              NetworkImage(
                                'https://tse2.mm.bing.net/th/id/OIP.Erb0ExAqXl5-gVYmqBv_uAHaE8',
                              ),
                              NetworkImage(
                                'https://cdn.pixabay.com/photo/2017/07/12/17/17/sunset-2497594_960_720.png',
                              ),
                            ],
                            imageRadius: 18.0,
                            overlapOffset: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  //  Slide View All in/out
                  AnimatedSlide(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    offset: _isVisible ? Offset.zero : const Offset(1.5, 0),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        AppLocalizations.of(context)!.view_all,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Product List
            ListView.builder(
              itemCount: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return const ProductCard();
              },
            ),
          ],
        ),
      ),
    );
  }
}
