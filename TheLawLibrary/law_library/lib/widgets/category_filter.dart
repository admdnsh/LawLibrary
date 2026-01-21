import 'package:flutter/material.dart';
import 'package:law_library/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:law_library/providers/theme_provider.dart';

class CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final Function(String?) onCategoryChanged;

  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final uiDensity = themeProvider.uiDensity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity),
            bottom: AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity),
          ),
          child: Text(
            'Filter by Category',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
        ),
        SizedBox(
          height: 48,
          child: categories.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length + 1, // +1 for "All" option
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // "All" option
                      return _buildCategoryChip(
                        context,
                        'All',
                        selectedCategory == null,
                        () => onCategoryChanged(null),
                      );
                    }

                    final category = categories[index - 1];
                    final isSelected = category == selectedCategory;

                    return _buildCategoryChip(
                      context,
                      category,
                      isSelected,
                      () => onCategoryChanged(category),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final uiDensity = themeProvider.uiDensity;

    return Padding(
      padding: EdgeInsets.only(
          right: AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity)),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        selectedColor: Theme.of(context).colorScheme.primary,
        onSelected: (selected) {
          if (selected) {
            onTap();
          }
        },
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: AppTheme.elevationSmall,
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity),
          vertical: AppTheme.getSpacing(AppTheme.baseSpacing8, uiDensity),
        ),
      ),
    );
  }
}
