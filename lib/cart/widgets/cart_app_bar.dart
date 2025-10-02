import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CartAppBar({super.key});

  @override
  State<CartAppBar> createState() => _CartAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _CartAppBarState extends State<CartAppBar> {
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = DefaultTabController.of(context);
    controller.addListener(() {
      if (!controller.indexIsChanging) {
        setState(() => _currentIndex = controller.index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Text(
          _currentIndex == 0 ? "My Cart" : "Shared Cart",
          key: ValueKey(_currentIndex),
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
      ),
      actions: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _currentIndex == 1
              ? IconButton(
                  key: const ValueKey('addPerson'),
                  icon: const Icon(Icons.person_add),
                  onPressed: () {},
                )
              : const SizedBox.shrink(key: ValueKey('empty')),
        ),
      ],
      bottom: TabBar(
        indicatorColor: const Color(0xFF8A5A39), // brown
        labelColor: Colors.black,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 3,
        tabs: [
          Tab(
            child: Text(
              "My Cart",
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Tab(
            child: Text(
              "Shared Cart",
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
