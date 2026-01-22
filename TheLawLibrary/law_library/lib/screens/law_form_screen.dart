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

  late final TextEditingController _chapterController;
  late final TextEditingController _categoryController;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _compoundFineController;
  late final TextEditingController _secondCompoundFineController;
  late final TextEditingController _thirdCompoundFineController;
  late final TextEditingController _fourthCompoundFineController;
  late final TextEditingController _fifthCompoundFineController;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _chapterController = TextEditingController(text: widget.law?.chapter ?? '');
    _categoryController = TextEditingController(text: widget.law?.category ?? '');
    _titleController = TextEditingController(text: widget.law?.title ?? '');
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
  }

  @override
  void dispose() {
    _chapterController.dispose();
    _categoryController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _compoundFineController.dispose();
    _secondCompoundFineController.dispose();
    _thirdCompoundFineController.dispose();
    _fourthCompoundFineController.dispose();
    _fifthCompoundFineController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final lawProvider = context.read<LawProvider>();

    final law = Law(
      chapter: _chapterController.text.trim(),
      category: _categoryController.text.trim(),
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
        : await lawProvider.updateLaw(law, originalChapter: widget.law!.chapter);

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? widget.law == null
            ? 'Law added successfully'
            : 'Law updated successfully'
            : 'Failed to save law'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (success) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final spacing = AppTheme.getSpacing(AppTheme.baseSpacing16, themeProvider.uiDensity);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.law == null ? 'Add Law' : 'Edit Law'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(spacing),
          children: [
            _buildSection(
              title: 'Law Information',
              children: [
                _textField(_chapterController, 'Chapter', required: true, key: UniqueKey()),
                _textField(_categoryController, 'Category', required: true, key: UniqueKey()),
                _textField(_titleController, 'Title', required: true, key: UniqueKey()),
              ],
            ),
            _buildSection(
              title: 'Offence Details',
              children: [
                _textField(
                  _descriptionController,
                  'Description',
                  required: true,
                  maxLines: 4,
                  key: UniqueKey(),
                ),
              ],
            ),
            _buildSection(
              title: 'Compound Fines',
              subtitle: 'Enter applicable fines (optional)',
              children: [
                _numberField(_compoundFineController, 'First Offence', key: UniqueKey()),
                _numberField(_secondCompoundFineController, 'Second Offence', key: UniqueKey()),
                _numberField(_thirdCompoundFineController, 'Third Offence', key: UniqueKey()),
                _numberField(_fourthCompoundFineController, 'Fourth Offence', key: UniqueKey()),
                _numberField(_fifthCompoundFineController, 'Fifth Offence', key: UniqueKey()),
              ],
            ),
            SizedBox(height: spacing * 1.5),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
                  : Text(widget.law == null ? 'Save Law' : 'Update Law'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    String? subtitle,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          const SizedBox(height: 12),
          ...children,
        ]),
      ),
    );
  }

  Widget _textField(
      TextEditingController controller,
      String label, {
        bool required = false,
        int maxLines = 1,
        Key? key,
      }) {
    return Padding(
      key: key,
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label),
        validator: required
            ? (value) => value == null || value.isEmpty ? 'Required field' : null
            : null,
      ),
    );
  }

  Widget _numberField(TextEditingController controller, String label, {Key? key}) {
    return Padding(
      key: key,
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: label),
        validator: null,
      ),
    );
  }
}
