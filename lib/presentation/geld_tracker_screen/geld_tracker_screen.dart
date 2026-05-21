
import '../../core/app_export.dart';
import '../../widgets/app_navigation.dart';
import './widgets/add_money_block_sheet_widget.dart';
import './widgets/geld_tracker_app_bar_widget.dart';
import './widgets/money_block_card_widget.dart';

// TODO: Replace with Riverpod/Bloc for production state management
class GeldTrackerScreen extends StatefulWidget {
  const GeldTrackerScreen({super.key});

  @override
  State<GeldTrackerScreen> createState() => _GeldTrackerScreenState();
}

class _GeldTrackerScreenState extends State<GeldTrackerScreen> {
  int _navIndex = 1;
  bool _isLoading = true;
  bool _showAllBlocks = false; // Admin toggle

  // Mock current user
  final Map<String, dynamic> _currentUser = {
    'firstName': 'Thomas',
    'lastName': 'Bergmann',
    'role': 'Admin',
    'avatarUrl':
        'https://img.rocket.new/generatedImages/rocket_gen_img_1dc64ab65-1763293842844.png',
    'avatarSemanticLabel': 'Profilbild von Thomas Bergmann',
  };

  // Mock money blocks — TODO: Replace with API data
  final List<Map<String, dynamic>> _blockMaps = [
    {
      'id': 'blk_001',
      'title': 'Haushaltskasse',
      'description': 'Gemeinsame Ausgaben für Lebensmittel und Haushalt',
      'owner': 'Thomas Bergmann',
      'sharedWith': ['Maria Bergmann', 'Sophie Bergmann'],
      'isShared': true,
      'bookings': [
        {
          'id': 'bk_001',
          'amount': 500.00,
          'title': 'Monatlicher Beitrag Thomas',
          'description': 'Einzahlung Mai 2026',
          'creator': 'Thomas Bergmann',
          'date': '2026-05-01',
        },
        {
          'id': 'bk_002',
          'amount': 300.00,
          'title': 'Monatlicher Beitrag Maria',
          'description': 'Einzahlung Mai 2026',
          'creator': 'Maria Bergmann',
          'date': '2026-05-02',
        },
        {
          'id': 'bk_003',
          'amount': -87.50,
          'title': 'Supermarkt Edeka',
          'description': 'Wocheneinkauf KW 19',
          'creator': 'Maria Bergmann',
          'date': '2026-05-10',
        },
        {
          'id': 'bk_004',
          'amount': -42.30,
          'title': 'Drogerie dm',
          'description': 'Haushaltsbedarf',
          'creator': 'Sophie Bergmann',
          'date': '2026-05-14',
        },
        {
          'id': 'bk_005',
          'amount': -124.80,
          'title': 'Supermarkt Rewe',
          'description': 'Großeinkauf Wochenende',
          'creator': 'Thomas Bergmann',
          'date': '2026-05-17',
        },
      ],
    },
    {
      'id': 'blk_002',
      'title': 'Urlaubskasse 2026',
      'description': 'Sommerurlaub Italien – Familienreise August',
      'owner': 'Thomas Bergmann',
      'sharedWith': ['Maria Bergmann'],
      'isShared': true,
      'bookings': [
        {
          'id': 'bk_006',
          'amount': 800.00,
          'title': 'Spareinlage Thomas',
          'description': 'April-Sparbeitrag',
          'creator': 'Thomas Bergmann',
          'date': '2026-04-05',
        },
        {
          'id': 'bk_007',
          'amount': 600.00,
          'title': 'Spareinlage Maria',
          'description': 'April-Sparbeitrag',
          'creator': 'Maria Bergmann',
          'date': '2026-04-06',
        },
        {
          'id': 'bk_008',
          'amount': 500.00,
          'title': 'Spareinlage Thomas',
          'description': 'Mai-Sparbeitrag',
          'creator': 'Thomas Bergmann',
          'date': '2026-05-05',
        },
        {
          'id': 'bk_009',
          'amount': -1240.00,
          'title': 'Flugtickets gebucht',
          'description': 'München → Rom, 4 Personen, Ryanair',
          'creator': 'Thomas Bergmann',
          'date': '2026-05-12',
        },
      ],
    },
    {
      'id': 'blk_003',
      'title': 'Auto-Rücklage',
      'description': 'Reparaturen, TÜV und Versicherung',
      'owner': 'Thomas Bergmann',
      'sharedWith': [],
      'isShared': false,
      'bookings': [
        {
          'id': 'bk_010',
          'amount': 200.00,
          'title': 'Monatliche Einlage',
          'description': 'März 2026',
          'creator': 'Thomas Bergmann',
          'date': '2026-03-01',
        },
        {
          'id': 'bk_011',
          'amount': 200.00,
          'title': 'Monatliche Einlage',
          'description': 'April 2026',
          'creator': 'Thomas Bergmann',
          'date': '2026-04-01',
        },
        {
          'id': 'bk_012',
          'amount': -380.00,
          'title': 'Hauptuntersuchung + Reparatur',
          'description': 'KFZ Schreiber – Bremsscheiben vorne',
          'creator': 'Thomas Bergmann',
          'date': '2026-05-18',
        },
      ],
    },
  ];

  List<Map<String, dynamic>> _blocks = [];
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    _loadBlocks();
  }

  void _loadBlocks() async {
    // TODO: Replace with real API call to fetch money blocks
    await Future.delayed(const Duration(milliseconds: 700));
    if (mounted) {
      setState(() {
        _blocks = _blockMaps;
        _isLoading = false;
      });
    }
  }

  double _totalBalance() {
    double total = 0;
    for (final block in _blocks) {
      final bookings = block['bookings'] as List<Map<String, dynamic>>;
      for (final b in bookings) {
        total += (b['amount'] as num).toDouble();
      }
    }
    return total;
  }

  void _showAddBlockSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddMoneyBlockSheetWidget(
        onSave: (block) {
          // TODO: Replace with real API call to create money block
          setState(() {
            _blocks = [..._blocks, block];
          });
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _showAddBookingSheet(int blockIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddBookingSheet(
        blockTitle: _blocks[blockIndex]['title'] as String,
        currentUser: _currentUser,
        onSave: (booking) {
          // TODO: Replace with real API call to add booking to block
          setState(() {
            final updatedBlock = Map<String, dynamic>.from(_blocks[blockIndex]);
            final bookings = List<Map<String, dynamic>>.from(
              updatedBlock['bookings'] as List,
            );
            bookings.add(booking);
            updatedBlock['bookings'] = bookings;
            final updated = List<Map<String, dynamic>>.from(_blocks);
            updated[blockIndex] = updatedBlock;
            _blocks = updated;
          });
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _onNavTap(int index) {
    if (index == 0) {
      Navigator.pushNamed(context, AppRoutes.bersichtScreen);
    } else {
      setState(() => _navIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final isAdmin = _currentUser['role'] == 'Admin';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: isTablet ? _buildTabletLayout(isAdmin) : _buildPhoneLayout(isAdmin),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddBlockSheet,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Neuer Block'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: isTablet
          ? null
          : AppNavigation(
              currentIndex: _navIndex,
              onDestinationSelected: _onNavTap,
            ),
    );
  }

  Widget _buildPhoneLayout(bool isAdmin) {
    return SafeArea(
      child: Column(
        children: [
          GeldTrackerAppBarWidget(
            user: _currentUser,
            totalBalance: _isLoading ? null : _totalBalance(),
            isAdmin: isAdmin,
            showAllBlocks: _showAllBlocks,
            onToggleAll: isAdmin
                ? () => setState(() => _showAllBlocks = !_showAllBlocks)
                : null,
          ),
          Expanded(child: _buildBlockList(isAdmin, false)),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(bool isAdmin) {
    return SafeArea(
      child: Row(
        children: [
          AppNavigation(
            currentIndex: _navIndex,
            onDestinationSelected: _onNavTap,
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              children: [
                GeldTrackerAppBarWidget(
                  user: _currentUser,
                  totalBalance: _isLoading ? null : _totalBalance(),
                  isAdmin: isAdmin,
                  showAllBlocks: _showAllBlocks,
                  onToggleAll: isAdmin
                      ? () => setState(() => _showAllBlocks = !_showAllBlocks)
                      : null,
                ),
                Expanded(child: _buildBlockList(isAdmin, true)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockList(bool isAdmin, bool isTablet) {
    if (_isLoading) {
      return SkeletonListWidget(itemCount: 3, itemHeight: 110);
    }

    if (_blocks.isEmpty) {
      return EmptyStateWidget(
        iconName: 'account_balance_wallet',
        title: 'Keine Geld-Blöcke vorhanden',
        subtitle:
            'Erstelle deinen ersten Geld-Block, um Buchungen zu verwalten.',
        actionLabel: 'Block erstellen',
        onAction: _showAddBlockSheet,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() => _isLoading = true);
        await Future.delayed(const Duration(milliseconds: 800));
        // TODO: Replace with real refresh API call
        setState(() => _isLoading = false);
      },
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(
          isTablet ? 24 : 16,
          16,
          isTablet ? 24 : 16,
          100,
        ),
        itemCount: _blocks.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: MoneyBlockCardWidget(
              block: _blocks[index],
              isExpanded: _expandedIndex == index,
              isAdmin: isAdmin,
              animationIndex: index,
              onToggleExpand: () {
                setState(() {
                  _expandedIndex = _expandedIndex == index ? null : index;
                });
              },
              onAddBooking: () => _showAddBookingSheet(index),
              onDelete: isAdmin
                  ? () {
                      showDialog(
                        context: context,
                        builder: (ctx) => _DeleteBlockDialog(
                          blockTitle: _blocks[index]['title'] as String,
                          onConfirm: () {
                            // TODO: Replace with real API call to delete block
                            setState(() {
                              final updated = List<Map<String, dynamic>>.from(
                                _blocks,
                              );
                              updated.removeAt(index);
                              _blocks = updated;
                              if (_expandedIndex == index) {
                                _expandedIndex = null;
                              }
                            });
                            Navigator.pop(ctx);
                          },
                        ),
                      );
                    }
                  : null,
            ),
          );
        },
      ),
    );
  }
}

// ─── Delete Confirmation Dialog ───────────────────────────────────────────────

class _DeleteBlockDialog extends StatelessWidget {
  final String blockTitle;
  final VoidCallback onConfirm;

  const _DeleteBlockDialog({required this.blockTitle, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Block löschen?', style: theme.textTheme.titleLarge),
      content: Text(
        'Möchtest du den Block „$blockTitle" wirklich löschen? Alle enthaltenen Buchungen werden ebenfalls entfernt. Diese Aktion kann nicht rückgängig gemacht werden.',
        style: theme.textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: onConfirm,
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.errorColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Löschen'),
        ),
      ],
    );
  }
}

// ─── Add Booking Bottom Sheet ─────────────────────────────────────────────────

class _AddBookingSheet extends StatefulWidget {
  final String blockTitle;
  final Map<String, dynamic> currentUser;
  final void Function(Map<String, dynamic>) onSave;

  const _AddBookingSheet({
    required this.blockTitle,
    required this.currentUser,
    required this.onSave,
  });

  @override
  State<_AddBookingSheet> createState() => _AddBookingSheetState();
}

class _AddBookingSheetState extends State<_AddBookingSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isPositive = true;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    // TODO: Replace with real API call to add booking
    await Future.delayed(const Duration(milliseconds: 400));

    final raw =
        double.tryParse(_amountController.text.trim().replaceAll(',', '.')) ??
        0.0;
    final amount = _isPositive ? raw.abs() : -raw.abs();
    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    widget.onSave({
      'id': 'bk_${now.millisecondsSinceEpoch}',
      'amount': amount,
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'creator':
          '${widget.currentUser['firstName']} ${widget.currentUser['lastName']}',
      'date': dateStr,
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
            Text('Buchung hinzufügen', style: theme.textTheme.headlineMedium),
            Text(widget.blockTitle, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 20),
            // Positive / Negative toggle
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isPositive = true),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _isPositive
                              ? AppTheme.success
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_rounded,
                              size: 16,
                              color: _isPositive
                                  ? Colors.white
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Einnahme',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: _isPositive
                                    ? Colors.white
                                    : theme.colorScheme.onSurfaceVariant,
                                fontWeight: _isPositive
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isPositive = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: !_isPositive
                              ? AppTheme.errorColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.remove_rounded,
                              size: 16,
                              color: !_isPositive
                                  ? Colors.white
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Ausgabe',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: !_isPositive
                                    ? Colors.white
                                    : theme.colorScheme.onSurfaceVariant,
                                fontWeight: !_isPositive
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Betrag (€)',
                prefixIcon: Icon(
                  _isPositive ? Icons.add_rounded : Icons.remove_rounded,
                  color: _isPositive ? AppTheme.success : AppTheme.errorColor,
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Betrag eingeben';
                final parsed = double.tryParse(v.replaceAll(',', '.'));
                if (parsed == null || parsed <= 0) {
                  return 'Ungültiger Betrag';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Titel',
                prefixIcon: Icon(Icons.receipt_long_rounded),
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Titel eingeben' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Beschreibung (optional)',
                prefixIcon: Icon(Icons.description_rounded),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 8),
            // Creator info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'person',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Erstellt von: ${widget.currentUser['firstName']} ${widget.currentUser['lastName']}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
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
                    : const Text('Buchung speichern'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
