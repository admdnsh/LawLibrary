import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:law_library/models/law.dart';
import 'package:law_library/providers/law_provider.dart';
import 'package:law_library/theme/app_theme.dart';
import 'package:law_library/providers/theme_provider.dart';

class LawFormScreen extends StatefulWidget {
  final Law? law;

  const LawFormScreen({super.key, this.law});

  @override
  State<LawFormScreen> createState() => _LawFormScreenState();
}

class _LawFormScreenState extends State<LawFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Fixed category options
  static const List<String> _categoryOptions = [
    'Road Traffic Act',
    'Road Traffic Regulations',
    'Docket',
    'Other',
  ];

  late final TextEditingController _chapterController;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _compoundFineController;
  late final TextEditingController _secondCompoundFineController;
  late final TextEditingController _thirdCompoundFineController;
  late final TextEditingController _fourthCompoundFineController;
  late final TextEditingController _fifthCompoundFineController;
  late final TextEditingController _otherCategoryController;

  String? _selectedCategory;
  bool get _isOtherCategory => _selectedCategory == 'Other';

  bool _isSubmitting = false;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _chapterController =
        TextEditingController(text: widget.law?.chapter ?? '');
    _titleController =
        TextEditingController(text: widget.law?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.law?.description ?? '');
    _compoundFineController =
        TextEditingController(text: widget.law?.compoundFine ?? '');
    _secondCompoundFineController =
        TextEditingController(text: widget.law?.secondCompoundFine ?? '');
    _thirdCompoundFineController =
        TextEditingController(text: widget.law?.thirdCompoundFine ?? '');
    _fourthCompoundFineController =
        TextEditingController(text: widget.law?.fourthCompoundFine ?? '');
    _fifthCompoundFineController =
        TextEditingController(text: widget.law?.fifthCompoundFine ?? '');

    // Initialise category — preselect if it matches a fixed option,
    // otherwise fall back to Other with the value in the free text field
    final existingCategory = widget.law?.category ?? '';
    if (existingCategory.isEmpty) {
      _selectedCategory = null;
      _otherCategoryController = TextEditingController();
    } else if (_categoryOptions.contains(existingCategory)) {
      _selectedCategory = existingCategory;
      _otherCategoryController = TextEditingController();
    } else {
      _selectedCategory = 'Other';
      _otherCategoryController =
          TextEditingController(text: existingCategory);
    }

    // Mark form dirty on any field change
    for (final controller in [
      _chapterController,
      _titleController,
      _descriptionController,
      _compoundFineController,
      _secondCompoundFineController,
      _thirdCompoundFineController,
      _fourthCompoundFineController,
      _fifthCompoundFineController,
      _otherCategoryController,
    ]) {
      controller.addListener(() {
        if (!_hasUnsavedChanges && mounted) {
          setState(() => _hasUnsavedChanges = true);
        }
      });
    }
  }

  @override
  void dispose() {
    _chapterController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _compoundFineController.dispose();
    _secondCompoundFineController.dispose();
    _thirdCompoundFineController.dispose();
    _fourthCompoundFineController.dispose();
    _fifthCompoundFineController.dispose();
    _otherCategoryController.dispose();
    super.dispose();
  }

  // Resolve final category value for saving
  String get _resolvedCategory {
    if (_isOtherCategory) return _otherCategoryController.text.trim();
    return _selectedCategory ?? '';
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final lawProvider = context.read<LawProvider>();

    final law = Law(
      chapter: _chapterController.text.trim(),
      category: _resolvedCategory,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      compoundFine: _compoundFineController.text.trim(),
      secondCompoundFine: _secondCompoundFineController.text.trim(),
      thirdCompoundFine: _thirdCompoundFineController.text.trim(),
      fourthCompoundFine: _fourthCompoundFineController.text.trim(),
      fifthCompoundFine: _fifthCompoundFineController.text.trim(),
    );

    final success = widget.law == null
        ? await lawProvider.createLaw(law)
        : await lawProvider.updateLaw(law,
        originalChapter: widget.law!.chapter);

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? widget.law == null
            ? 'Law added successfully'
            : 'Law updated successfully'
            : 'Failed to save law'),
        backgroundColor:
        success ? Colors.green : Theme.of(context).colorScheme.error,
      ),
    );

    if (success) {
      setState(() => _hasUnsavedChanges = false);
      Navigator.pop(context);
    }
  }

  // --------------------------------------------------
  // BUILD
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final spacing =
    AppTheme.getSpacing(AppTheme.baseSpacing16, themeProvider.uiDensity);

    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Discard changes?'),
            content: const Text(
                'You have unsaved changes. Are you sure you want to go back?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Keep editing'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Discard',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
        );
        if (shouldPop == true && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.law == null ? 'Add Law' : 'Edit Law'),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(spacing),
            children: [
              // ── Law Information ──────────────────────────────
              _buildSection(
                title: 'Law Information',
                icon: Icons.gavel_outlined,
                children: [
                  _textField(
                    _chapterController,
                    'Chapter',
                    required: true,
                    hint: 'e.g. 68(1)(a)',
                  ),
                  _buildCategoryDropdown(),
                  _textField(_titleController, 'Title', required: true),
                ],
              ),

              // ── Offence Details ──────────────────────────────
              _buildSection(
                title: 'Offence Details',
                icon: Icons.description_outlined,
                children: [
                  _textField(
                    _descriptionController,
                    'Description',
                    required: true,
                    maxLines: 4,
                    hint: 'Enter the full offence description',
                  ),
                ],
              ),

              // ── Compound Fines ───────────────────────────────
              _buildSection(
                title: 'Compound Fines',
                icon: Icons.monetization_on_outlined,
                subtitle: 'Enter applicable fines in BND (optional)',
                children: [
                  _numberField(_compoundFineController, '1st Offence'),
                  _numberField(_secondCompoundFineController, '2nd Offence'),
                  _numberField(_thirdCompoundFineController, '3rd Offence'),
                  _numberField(_fourthCompoundFineController, '4th Offence'),
                  _numberField(_fifthCompoundFineController, '5th Offence'),
                ],
              ),

              SizedBox(height: spacing * 1.5),

              // ── Submit button ────────────────────────────────
              FilledButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        AppTheme.borderRadiusMedium),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
                    : Text(
                  widget.law == null ? 'Save Law' : 'Update Law',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: spacing),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // CATEGORY DROPDOWN
  // --------------------------------------------------

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.category_outlined),
            ),
            hint: const Text('Select a category'),
            items: _categoryOptions
                .map((option) => DropdownMenuItem(
              value: option,
              child: Text(option),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
                _hasUnsavedChanges = true;
                if (value != 'Other') {
                  _otherCategoryController.clear();
                }
              });
            },
            validator: (value) =>
            value == null ? 'Please select a category' : null,
          ),
        ),

        // Free text field — only shown when Other is selected
        if (_isOtherCategory)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextFormField(
              controller: _otherCategoryController,
              decoration: const InputDecoration(
                labelText: 'Specify category',
                border: OutlineInputBorder(),
                hintText: 'Enter custom category name',
              ),
              validator: (value) =>
              _isOtherCategory && (value == null || value.trim().isEmpty)
                  ? 'Please specify the category'
                  : null,
            ),
          ),
      ],
    );
  }

  // --------------------------------------------------
  // SECTION CARD
  // --------------------------------------------------

  Widget _buildSection({
    required String title,
    required IconData icon,
    String? subtitle,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 26),
                child: Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // TEXT FIELD
  // --------------------------------------------------

  Widget _textField(
      TextEditingController controller,
      String label, {
        bool required = false,
        int maxLines = 1,
        String? hint,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
          alignLabelWithHint: maxLines > 1,
        ),
        validator: required
            ? (value) =>
        value == null || value.isEmpty ? 'Required field' : null
            : null,
      ),
    );
  }

  // --------------------------------------------------
  // NUMBER FIELD
  // --------------------------------------------------

  Widget _numberField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          hintText: 'e.g. 500',
          border: const OutlineInputBorder(),
          prefixText: 'BND ',
        ),
      ),
    );
  }
}