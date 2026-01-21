import 'package:flutter/material.dart';
import 'package:law_library/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:law_library/providers/theme_provider.dart';

class AppSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSearch;
  final String? hintText;

  const AppSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    this.hintText,
  });

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateClearButtonVisibility);
  }

  void _updateClearButtonVisibility() {
    final showClear = widget.controller.text.isNotEmpty;
    if (showClear != _showClearButton) {
      setState(() {
        _showClearButton = showClear;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final uiDensity = themeProvider.uiDensity;

    return Container(
      height: AppTheme.getSpacing(56, uiDensity),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(
            AppTheme.getSpacing(AppTheme.borderRadiusMedium, uiDensity)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Search laws...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _showClearButton
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    widget.controller.clear();
                    widget.onSearch('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity),
            vertical: AppTheme.getSpacing(AppTheme.baseSpacing12, uiDensity),
          ),
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: widget.onSearch,
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateClearButtonVisibility);
    super.dispose();
  }
}
