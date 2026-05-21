
import '../../../core/app_export.dart';
import './balance_chart_widget.dart';
import './booking_item_widget.dart';

class MoneyBlockCardWidget extends StatefulWidget {
  final Map<String, dynamic> block;
  final bool isExpanded;
  final bool isAdmin;
  final int animationIndex;
  final VoidCallback onToggleExpand;
  final VoidCallback onAddBooking;
  final VoidCallback? onDelete;

  const MoneyBlockCardWidget({
    super.key,
    required this.block,
    required this.isExpanded,
    required this.isAdmin,
    required this.animationIndex,
    required this.onToggleExpand,
    required this.onAddBooking,
    this.onDelete,
  });

  @override
  State<MoneyBlockCardWidget> createState() => _MoneyBlockCardWidgetState();
}

class _MoneyBlockCardWidgetState extends State<MoneyBlockCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    );
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOutCubic,
          ),
        );

    final delay = Duration(
      milliseconds: (widget.animationIndex * 80).clamp(0, 400),
    );
    Future.delayed(delay, () {
      if (mounted) _entranceController.forward();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  double _computeBalance() {
    final bookings = widget.block['bookings'] as List<Map<String, dynamic>>;
    double total = 0;
    for (final b in bookings) {
      total += (b['amount'] as num).toDouble();
    }
    return total;
  }

  String _formatCurrency(double amount) {
    final abs = amount.abs();
    final sign = amount < 0 ? '-' : '+';
    final parts = abs.toStringAsFixed(2).split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return '$sign $intPart,${parts[1]} €';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final balance = _computeBalance();
    final isPositive = balance >= 0;
    final bookings = widget.block['bookings'] as List<Map<String, dynamic>>;
    final isShared = widget.block['isShared'] as bool;

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.25 : 0.06),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header (always visible) ──────────────────────────
              InkWell(
                onTap: widget.onToggleExpand,
                borderRadius: BorderRadius.circular(20),
                splashColor: theme.colorScheme.primary.withAlpha(15),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Block icon
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: 'account_balance_wallet',
                                color: theme.colorScheme.primary,
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.block['title'] as String,
                                        style: theme.textTheme.titleMedium,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (isShared)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 6),
                                        child: StatusBadgeWidget(
                                          label: 'Geteilt',
                                          variant: BadgeVariant.info,
                                          compact: true,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.block['description'] as String,
                                  style: theme.textTheme.bodySmall,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          AnimatedRotation(
                            turns: widget.isExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutCubic,
                            child: CustomIconWidget(
                              iconName: 'expand_more',
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Balance + booking count row
                      Row(
                        children: [
                          // Balance chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isPositive
                                  ? AppTheme.successContainer
                                  : AppTheme.errorContainer,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: isPositive
                                      ? 'trending_up'
                                      : 'trending_down',
                                  color: isPositive
                                      ? AppTheme.success
                                      : AppTheme.errorColor,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _formatCurrency(balance),
                                  style: GoogleFonts.dmSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: isPositive
                                        ? AppTheme.success
                                        : AppTheme.errorColor,
                                    fontFeatures: const [
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          // Booking count badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: 'receipt_long',
                                  color: theme.colorScheme.onSurfaceVariant,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${bookings.length} Buchungen',
                                  style: theme.textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ── Expanded content ─────────────────────────────────
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: _buildExpandedContent(context, theme, bookings),
                crossFadeState: widget.isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
                sizeCurve: Curves.easeOutCubic,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedContent(
    BuildContext context,
    ThemeData theme,
    List<Map<String, dynamic>> bookings,
  ) {
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Divider
        Divider(
          color: theme.colorScheme.outlineVariant,
          thickness: 1,
          height: 1,
        ),

        // Balance trend chart
        if (bookings.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Saldoverlauf',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                BalanceChartWidget(bookings: bookings),
              ],
            ),
          ),

        // Bookings header + add button
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              Text('Buchungsverlauf', style: theme.textTheme.titleSmall),
              const Spacer(),
              TextButton.icon(
                onPressed: widget.onAddBooking,
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Hinzufügen'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  backgroundColor: theme.colorScheme.primaryContainer.withAlpha(
                    153,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Booking list
        if (bookings.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Text(
              'Noch keine Buchungen vorhanden.',
              style: theme.textTheme.bodySmall,
            ),
          )
        else
          ...bookings.reversed.map(
            (booking) => BookingItemWidget(booking: booking),
          ),

        // Admin actions
        if (widget.isAdmin && widget.onDelete != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.onDelete,
                    icon: const Icon(Icons.delete_outline_rounded, size: 16),
                    label: const Text('Block löschen'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.errorColor,
                      side: const BorderSide(color: AppTheme.errorColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      textStyle: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
