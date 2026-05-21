import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

class AddMoneyBlockSheetWidget extends StatefulWidget {
  final void Function(Map<String, dynamic> block) onSave;

  const AddMoneyBlockSheetWidget({super.key, required this.onSave});

  @override
  State<AddMoneyBlockSheetWidget> createState() =>
      _AddMoneyBlockSheetWidgetState();
}

class _AddMoneyBlockSheetWidgetState extends State<AddMoneyBlockSheetWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    // TODO: Replace with real API call to create money block
    await Future.delayed(const Duration(milliseconds: 400));

    widget.onSave({
      'id': 'blk_${DateTime.now().millisecondsSinceEpoch}',
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'owner': 'Thomas Bergmann',
      'sharedWith': [],
      'isShared': false,
      'bookings': <Map<String, dynamic>>[],
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomInset),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Neuer Geld-Block', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 6),
            Text(
              'Erstelle einen neuen Block zur Finanzverwaltung.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Block-Titel',
                prefixIcon: Icon(Icons.account_balance_wallet_rounded),
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Titel eingeben' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Beschreibung',
                prefixIcon: Icon(Icons.description_rounded),
                alignLabelWithHint: true,
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Beschreibung eingeben' : null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Text('Block erstellen'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
