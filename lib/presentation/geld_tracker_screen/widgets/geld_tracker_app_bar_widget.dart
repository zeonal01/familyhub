
import '../../../core/app_export.dart';

class GeldTrackerAppBarWidget extends StatelessWidget {
  final Map<String, dynamic> user;
  final double? totalBalance;
  final bool isAdmin;
  final bool showAllBlocks;
  final VoidCallback? onToggleAll;

  const GeldTrackerAppBarWidget({
    super.key,
    required this.user,
    required this.totalBalance,
    required this.isAdmin,
    required this.showAllBlocks,
    this.onToggleAll,
  });

  String _formatCurrency(double amount) {
    final abs = amount.abs();
    final sign = amount < 0 ? '-' : '';
    final parts = abs.toStringAsFixed(2).split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return '$sign$intPart,${parts[1]} €';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final balance = totalBalance;

    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: avatar + title + bell
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: CustomImageWidget(
                  imageUrl: user['avatarUrl'] as String,
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                  semanticLabel: user['avatarSemanticLabel'] as String,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Geld-Tracker',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Deine Finanzblöcke',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (isAdmin && onToggleAll != null)
                TextButton.icon(
                  onPressed: onToggleAll,
                  icon: Icon(
                    showAllBlocks ? Icons.group_rounded : Icons.person_rounded,
                    size: 16,
                  ),
                  label: Text(
                    showAllBlocks ? 'Alle' : 'Meine',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    backgroundColor: theme.colorScheme.primaryContainer
                        .withAlpha(128),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Balance summary card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withAlpha(204),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withAlpha(77),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gesamtsaldo',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withAlpha(204),
                        ),
                      ),
                      const SizedBox(height: 4),
                      balance == null
                          ? Container(
                              width: 120,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(51),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            )
                          : Text(
                              _formatCurrency(balance),
                              style: GoogleFonts.dmSans(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
