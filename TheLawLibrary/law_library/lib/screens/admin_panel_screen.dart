import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:law_library/providers/law_provider.dart';
import 'package:law_library/models/law.dart';
import 'package:law_library/theme/app_theme.dart';
import 'package:law_library/screens/law_form_screen.dart';
import 'package:law_library/providers/theme_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch initial laws when the screen is created
    Provider.of<LawProvider>(context, listen: false).fetchLaws(refresh: true);

    // Add a listener for infinite scrolling if needed later
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
    //     // Load more laws
    //   }
    // });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final uiDensity = themeProvider.uiDensity;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: Consumer<LawProvider>(
        builder: (context, lawProvider, _) {
          if (lawProvider.isLoading && lawProvider.laws.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(
                    AppTheme.getSpacing(AppTheme.baseSpacing16, uiDensity)),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search Laws',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.getSpacing(
                          AppTheme.borderRadiusMedium, uiDensity)),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  onChanged: (query) {
                    // Reset to first page on search
                    lawProvider.setSearchQuery(query);
                    lawProvider.fetchLaws(refresh: true);
                  },
                ),
              ),
              if (lawProvider.laws.isEmpty && !lawProvider.isLoading)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.5),
                        ),
                        SizedBox(
                            height: AppTheme.getSpacing(
                                AppTheme.baseSpacing16, uiDensity)),
                        Text(
                          'No laws found',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(
                            height: AppTheme.getSpacing(
                                AppTheme.baseSpacing8, uiDensity)),
                        Text(
                          'Try adjusting your search criteria',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ).animate().fadeIn().scale(),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(
                        horizontal: AppTheme.getSpacing(
                            AppTheme.baseSpacing16, uiDensity)),
                    itemCount: lawProvider.laws.length,
                    itemBuilder: (context, index) {
                      final law = lawProvider.laws[index];
                      return Card(
                        margin: EdgeInsets.only(
                            bottom: AppTheme.getSpacing(
                                AppTheme.baseSpacing16, uiDensity)),
                        child: ListTile(
                          title: Text(law.title),
                          subtitle: Text(law.description),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          LawFormScreen(law: law),
                                    ),
                                  );
                                },
                                tooltip: 'Edit Law',
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete Law'),
                                      content: const Text(
                                        'Are you sure you want to delete this law? This action cannot be undone.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: Text(
                                            'Delete',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirmed == true) {
                                    final success = await lawProvider
                                        .deleteLaw(law.chapter);
                                    if (success && context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Law deleted successfully'),
                                        ),
                                      );
                                    }
                                  }
                                },
                                tooltip: 'Delete Law',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              if (!lawProvider.isLoadingMore && !lawProvider.isLoading)
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: AppTheme.getSpacing(
                          AppTheme.baseSpacing16, uiDensity)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: lawProvider.currentPage > 1
                            ? () =>
                                lawProvider.setPage(lawProvider.currentPage - 1)
                            : null,
                        tooltip: 'Previous Page',
                      ),
                      Text('Page ${lawProvider.currentPage}'),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: lawProvider.hasMorePages
                            ? () =>
                                lawProvider.setPage(lawProvider.currentPage + 1)
                            : null,
                        tooltip: 'Next Page',
                      ),
                    ],
                  ),
                ),
              if (lawProvider.isLoadingMore)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LawFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add New Law',
      ),
    );
  }
}
