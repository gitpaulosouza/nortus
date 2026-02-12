import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nortus/src/core/themes/app_colors.dart';
import 'package:nortus/src/core/widgets/nortus_nav_item.dart';

class NortusAppBar extends StatelessWidget implements PreferredSizeWidget {
  final NortusNavItem activeItem;

  const NortusAppBar({super.key, required this.activeItem});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryBackground,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 80,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          children: [
            Image.asset(
              'assets/images/nortus-logo.png',
              height: 24,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 24),
            _buildNavItem(
              context,
              item: NortusNavItem.news,
              isActive: activeItem == NortusNavItem.news,
            ),
            _buildNavItem(
              context,
              item: NortusNavItem.profile,
              isActive: activeItem == NortusNavItem.profile,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required NortusNavItem item,
    required bool isActive,
  }) {
    return TextButton(
      onPressed: () => context.go(item.route),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        item.label,
        style: TextStyle(
          color: AppColors.white,
          fontSize: 14,
          fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
    );
  }
}
