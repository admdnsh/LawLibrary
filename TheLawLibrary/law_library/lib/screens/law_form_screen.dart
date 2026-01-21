// lib/screens/law_form_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:law_library/models/law.dart';
import 'package:law_library/providers/law_provider.dart';
import 'package:law_library/theme/app_theme.dart';
import 'package:law_library/providers/theme_provider.dart';

class LawFormScreen extends StatefulWidget {
  final Law?
      law; // If null, we're adding a new law. If not null, we're editing.

  const LawFormScreen({
    super.key,
    this.law,
  });

  @override
  State<LawFormScreen> createState() => _LawFormScreenState();
}

class _LawFormScreenState extends State<LawFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _chapterController;
  late TextEditingController _categoryController;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _compoundFineController;
  late TextEditingController _secondCompoundFineController;
  late TextEditingController _thirdCompoundFineController;
  late TextEditingController _fourthCompoundFineController;
  late TextEditingController _fifthCompoundFineController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing law data if editing
    _chapterController = TextEditingController(text: widget.law?.chapter ?? '');
    _categoryController =
        TextEditingController(text: widget.law?.category ?? '');
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
    if (_formKey.currentState!.validate()) {
      final lawProvider = Provider.of<LawProvider>(context, listen: false);

      print('Original Law: ${widget.law?.toJson()}'); // Debug log
      print('New Chapter: ${_chapterController.text}'); // Debug log

      final law = Law(
        chapter: _chapterController
            .text, // MODIFIED: Always use the controller text for the Law object
        category: _categoryController.text,
        title: _titleController.text,
        description: _descriptionController.text,
        compoundFine: _compoundFineController.text,
        secondCompoundFine: _secondCompoundFineController.text,
        thirdCompoundFine: _thirdCompoundFineController.text,
        fourthCompoundFine: _fourthCompoundFineController.text,
        fifthCompoundFine: _fifthCompoundFineController.text,
      );

      print('Submitting Law: ${law.toJson()}'); // Debug log

      bool success;
      if (widget.law == null) {
        // Adding new law
        success = await lawProvider.createLaw(law);
      } else {
        // Updating existing law
        // MODIFIED: Pass the original chapter to identify the record in the backend
        success = await lawProvider.updateLaw(law,
            originalChapter: widget.law!.chapter);
      }

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.law == null
                ? 'Law added successfully'
                : 'Law updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save law'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<ThemeProvider>(context); // Get ThemeProvider
    final uiDensity = themeProvider.uiDensity; // Get uiDensity
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.law == null ? 'Add New Law' : 'Edit Law'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(AppTheme.getSpacing(
              AppTheme.baseSpacing16, uiDensity)), // Use dynamic spacing
          children: [
            TextFormField(
              controller: _chapterController,
              decoration: const InputDecoration(
                labelText: 'Chapter',
                hintText: 'Enter chapter number',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a chapter';
                }
                return null;
              },
            ),
            SizedBox(
                height: AppTheme.getSpacing(
                    AppTheme.baseSpacing16, uiDensity)), // Use dynamic spacing
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
                hintText: 'Enter category',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a category';
                }
                return null;
              },
            ),
            SizedBox(
                height: AppTheme.getSpacing(
                    AppTheme.baseSpacing16, uiDensity)), // Use dynamic spacing
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter title',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            SizedBox(
                height: AppTheme.getSpacing(
                    AppTheme.baseSpacing16, uiDensity)), // Use dynamic spacing
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter description',
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            SizedBox(
                height: AppTheme.getSpacing(
                    AppTheme.baseSpacing16, uiDensity)), // Use dynamic spacing
            TextFormField(
              controller: _compoundFineController,
              decoration: const InputDecoration(
                labelText: 'First Compound Fine',
                hintText: 'Enter first compound fine',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the first compound fine';
                }
                return null;
              },
            ),
            SizedBox(
                height: AppTheme.getSpacing(
                    AppTheme.baseSpacing16, uiDensity)), // Use dynamic spacing
            TextFormField(
              controller: _secondCompoundFineController,
              decoration: const InputDecoration(
                labelText: 'Second Compound Fine',
                hintText: 'Enter second compound fine',
              ),
            ),
            SizedBox(
                height: AppTheme.getSpacing(
                    AppTheme.baseSpacing16, uiDensity)), // Use dynamic spacing
            TextFormField(
              controller: _thirdCompoundFineController,
              decoration: const InputDecoration(
                labelText: 'Third Compound Fine',
                hintText: 'Enter third compound fine',
              ),
            ),
            SizedBox(
                height: AppTheme.getSpacing(
                    AppTheme.baseSpacing16, uiDensity)), // Use dynamic spacing
            TextFormField(
              controller: _fourthCompoundFineController,
              decoration: const InputDecoration(
                labelText: 'Fourth Compound Fine',
                hintText: 'Enter fourth compound fine',
              ),
            ),
            SizedBox(
                height: AppTheme.getSpacing(
                    AppTheme.baseSpacing16, uiDensity)), // Use dynamic spacing
            TextFormField(
              controller: _fifthCompoundFineController,
              decoration: const InputDecoration(
                labelText: 'Fifth Compound Fine',
                hintText: 'Enter fifth compound fine',
              ),
            ),
            SizedBox(
                height: AppTheme.getSpacing(
                    AppTheme.baseSpacing24, uiDensity)), // Use dynamic spacing
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(widget.law == null ? 'Add Law' : 'Update Law'),
            ),
          ],
        ),
      ),
    );
  }
}
