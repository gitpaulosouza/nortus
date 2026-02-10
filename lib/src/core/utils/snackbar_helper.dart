import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nortus/src/core/themes/app_colors.dart';

class SnackbarHelper {
  static OverlayEntry? _currentEntry;
  static Timer? _timer;

  static void showSuccess(
    BuildContext context,
    String title, {
    String? subtitle,
  }) {
    _showOverlay(
      context,
      title,
      subtitle: subtitle,
      backgroundColor: AppColors.success,
      icon: Icons.check,
      duration: const Duration(seconds: 3),
    );
  }

  static void showError(
    BuildContext context,
    String title, {
    String? subtitle,
  }) {
    _showOverlay(
      context,
      title,
      subtitle: subtitle,
      backgroundColor: Colors.red,
      icon: Icons.close,
      duration: const Duration(seconds: 3),
    );
  }

  static void _showOverlay(
    BuildContext context,
    String title, {
    String? subtitle,
    required Color backgroundColor,
    required IconData icon,
    required Duration duration,
  }) {
    _removeCurrent();

    final overlay = Overlay.of(context, rootOverlay: true);
    final topPadding = MediaQuery.of(context).padding.top;
    final topOffset = topPadding + kToolbarHeight + 8;

    _currentEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: topOffset,
          left: 16,
          right: 16,
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: backgroundColor, size: 16),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          if (subtitle != null && subtitle.trim().isNotEmpty)
                            Text(
                              subtitle,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _removeCurrent,
                    icon: const Icon(Icons.close, color: Colors.white),
                    iconSize: 18,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_currentEntry!);
    _timer = Timer(duration, _removeCurrent);
  }

  static void _removeCurrent() {
    _timer?.cancel();
    _timer = null;
    _currentEntry?.remove();
    _currentEntry = null;
  }
}
