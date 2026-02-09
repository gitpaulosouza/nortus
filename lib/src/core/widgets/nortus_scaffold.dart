import 'package:flutter/material.dart';
import 'package:nortus/src/core/widgets/nortus_app_bar.dart';
import 'package:nortus/src/core/widgets/nortus_footer.dart';
import 'package:nortus/src/core/widgets/nortus_nav_item.dart';

class NortusScaffold extends StatelessWidget {
  final Widget body;
  final bool showFooter;
  final bool showAppBar;
  final NortusNavItem activeItem;

  const NortusScaffold({
    super.key,
    required this.body,
    this.showFooter = true,
    this.showAppBar = true,
    required this.activeItem,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = SafeArea(top: false, bottom: false, child: body);

    return Scaffold(
      appBar: showAppBar ? NortusAppBar(activeItem: activeItem) : null,
      body: content,
      bottomNavigationBar: showFooter ? const NortusFooter() : null,
    );
  }
}
