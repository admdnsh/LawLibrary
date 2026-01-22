import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:law_library/models/law.dart';
import 'package:law_library/providers/law_provider.dart';
import 'package:law_library/providers/theme_provider.dart';
import 'package:law_library/theme/app_theme.dart';
import 'package:law_library/screens/law_form_screen.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<LawProvider>().fetchLaws(refresh: true);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<LawProvider>().setSearchQuery(query);
      context.read<LawProvider>().fetchLaws(refresh: true);
    });
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Law'),
        content: const Text(
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final uiDensity = themeProvider.uiDensity;
    final spacing =
    AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity);

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: Consumer<LawProvider>(
        builder: (context, lawProvider, _) {
          if (lawProvider.isLoading && lawProvider.laws.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              /// 🔍 Search Bar
              Padding(
                padding: EdgeInsets.all(spacing),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    labelText: 'Search laws',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor:
                    Theme.of(context).colorScheme.surfaceVariant,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppTheme.getSpacing(
                            AppTheme.borderRadiusMedium, uiDensity),
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              /// 📭 Empty State
              if (lawProvider.laws.isEmpty && !lawProvider.isLoading)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 64),
                        const SizedBox(height: 16),
                        Text(
                          'No laws found',
                          style:
                          Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Try adjusting your search or add a new law.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Add Law'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LawFormScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ).animate().fadeIn().scale(),
                  ),
                )

              /// 📜 Law List
              else
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () =>
                        lawProvider.fetchLaws(refresh: true),
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.fromLTRB(
                        spacing,
                        0,
                        spacing,
                        90, // FAB spacing
                      ),
                      itemCount: lawProvider.laws.length,
                      itemBuilder: (context, index) {
                        final Law law = lawProvider.laws[index];

                        return Card(
                          elevation: 1.5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin:
                          EdgeInsets.only(bottom: spacing),
                          child: ListTile(
                            title: Text(
                              'Chapter ${law.chapter} • ${law.title}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  law.description,
                                  maxLines: 2,
                                  overflow:
                                  TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Category: ${law.category}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall,
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  tooltip: 'Edit law',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            LawFormScreen(
                                                law: law),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .error,
                                  tooltip: 'Delete law',
                                  onPressed: () async {
                                    final confirmed =
                                    await _confirmDelete(
                                        context);
                                    if (confirmed) {
                                      final success =
                                      await lawProvider
                                          .deleteLaw(
                                          law.chapter);
                                      if (success &&
                                          context.mounted) {
                                        ScaffoldMessenger.of(
                                            context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Law deleted successfully'),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              /// ⏭ Pagination
              if (!lawProvider.isLoading)
                Padding(
                  padding:
                  EdgeInsets.symmetric(vertical: spacing),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed:
                        lawProvider.currentPage > 1
                            ? () => lawProvider.setPage(
                            lawProvider.currentPage -
                                1)
                            : null,
                      ),
                      Text(
                        'Page ${lawProvider.currentPage}'
                            '${lawProvider.hasMorePages ? '' : ' (Last)'}',
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed:
                        lawProvider.hasMorePages
                            ? () => lawProvider.setPage(
                            lawProvider.currentPage +
                                1)
                            : null,
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),

      /// ➕ Add Law
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Law'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const LawFormScreen(),
            ),
          );
        },
      ),
    );
  }
}
