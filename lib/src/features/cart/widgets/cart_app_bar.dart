import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/src/features/cart/widgets/invitaion_dialog.dart';
import 'package:decora/src/features/home/main_screen.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CartAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CartAppBar({super.key});

  @override
  State<CartAppBar> createState() => _CartAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _CartAppBarState extends State<CartAppBar> {
  int _currentIndex = 0;
  TabController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= DefaultTabController.of(context)
      ..addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (!_controller!.indexIsChanging) {
      setState(() => _currentIndex = _controller!.index);
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_handleTabChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tabTextStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    );

    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        l10n.cart,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      centerTitle: true,

      // Leading back button
      leading: Padding(
        padding: const EdgeInsets.only(left: 15.0, top: 8),
        child: Container(
          height: 30,
          decoration: BoxDecoration(
            color: AppColors.cardColor(context),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainLayout()),
              );
              MainLayout.currentIndex = 0;
            },

            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
      ),

      //  Actions
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),

          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _currentIndex == 1
                ? const _AddPersonButton(key: ValueKey('add'))
                : const SizedBox.shrink(),
          ),
        ),
      ],

      //  TabBar
      bottom: TabBar(
        indicatorColor: AppColors.orange(context),
        labelColor: Colors.black,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 3,
        tabs: [
          Tab(child: Text(l10n.my_cart, style: tabTextStyle)),
          Tab(child: Text(l10n.shared_cart, style: tabTextStyle)),
        ],
      ),
    );
  }
}

class _AddPersonButton extends StatelessWidget {
  const _AddPersonButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.primary(context),
      child: IconButton(
        icon: const Icon(Icons.person_add_alt, color: Colors.white),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const InvitationDialog(),
          );
        },
      ),
    );
  }
}
