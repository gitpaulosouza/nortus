import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nortus/src/core/themes/app_colors.dart';

class ProfileSearchBar extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;
  final String currentQuery;

  const ProfileSearchBar({
    super.key,
    required this.onSearchChanged,
    this.currentQuery = '',
  });

  @override
  State<ProfileSearchBar> createState() => _ProfileSearchBarState();
}

class _ProfileSearchBarState extends State<ProfileSearchBar> {
  late final TextEditingController _searchController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.currentQuery);
    _isEditing = widget.currentQuery.isNotEmpty;
  }

  @override
  void didUpdateWidget(ProfileSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentQuery != oldWidget.currentQuery &&
        widget.currentQuery != _searchController.text) {
      _searchController.text = widget.currentQuery;
      _isEditing = widget.currentQuery.isNotEmpty;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      widget.onSearchChanged(query);
    }
  }

  void _clearSearch() {
    _searchController.clear();
    widget.onSearchChanged('');
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: _isEditing ? _buildEditingMode() : _buildDefaultMode(),
    );
  }

  Widget _buildDefaultMode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset(
          'assets/images/nortus_wordmark.svg',
          height: 24,
          colorFilter: const ColorFilter.mode(
            AppColors.textPrimary,
            BlendMode.srcIn,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.search, size: 28),
          color: AppColors.textPrimary,
          onPressed: _startEditing,
        ),
      ],
    );
  }

  Widget _buildEditingMode() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            autofocus: true,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _performSearch(),
            decoration: InputDecoration(
              hintText: 'Digite sua busca...',
              hintStyle: TextStyle(
                color: AppColors.textParagraph.withValues(alpha: 0.6),
                fontSize: 14,
              ),
              suffixIcon: TextButton(
                onPressed: _performSearch,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                child: const Text(
                  'Pesquisar',
                  style: TextStyle(
                    color: AppColors.searchActionText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.searchBorderColor),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.searchBorderColor),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.searchBorderColor,
                  width: 1,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 0,
              ),
            ),
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.searchCloseButtonBorder,
              width: 1,
            ),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.close, size: 18),
            color: AppColors.searchCloseIcon,
            onPressed: _clearSearch,
          ),
        ),
      ],
    );
  }
}
