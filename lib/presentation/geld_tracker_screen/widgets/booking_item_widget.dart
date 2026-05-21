
import '../../../core/app_export.dart';

class BookingItemWidget extends StatelessWidget {
  final Map<String, dynamic> booking;

  const BookingItemWidget({super.key, required this.booking});

  String _formatAmount(double amount) {
    final abs = amount.abs();
    final sign = amount >= 0 ? '+' : '-';
    final parts = abs.toStringAsFixed(2).split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return '$sign $intPart,${parts[1]} €';
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final amount = (booking['amount'] as num).toDouble();
    final isPositive = amount >= 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(128),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Amount badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: isPositive
                  ? AppTheme.successContainer
                  : AppTheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _formatAmount(amount),
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isPositive ? AppTheme.success : AppTheme.errorColor,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Title + meta
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking['title'] as String,
                  style: theme.textTheme.titleSmall?.copyWith(fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if ((booking['description'] as String?)?.isNotEmpty == true)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      booking['description'] as String,
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'person',
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 11,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      booking['creator'] as String,
                      style: theme.textTheme.labelSmall,
                    ),
                    const Spacer(),
                    CustomIconWidget(
                      iconName: 'access_time',
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 11,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      _formatDate(booking['date'] as String),
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
