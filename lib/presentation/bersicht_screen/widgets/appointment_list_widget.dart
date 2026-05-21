
import '../../../core/app_export.dart';
import './appointment_card_widget.dart';

class AppointmentListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> appointments;
  final bool isLoading;
  final bool isTablet;

  const AppointmentListWidget({
    super.key,
    required this.appointments,
    this.isLoading = false,
    this.isTablet = false,
  });

  Map<String, List<Map<String, dynamic>>> _groupByDate() {
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final apt in appointments) {
      final date = apt['date'] as String;
      grouped.putIfAbsent(date, () => []).add(apt);
    }
    final sorted = Map.fromEntries(
      grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    return sorted;
  }

  String _formatSectionDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final tomorrow = today.add(const Duration(days: 1));
    final tomorrowStr =
        '${tomorrow.year}-${tomorrow.month.toString().padLeft(2, '0')}-${tomorrow.day.toString().padLeft(2, '0')}';

    if (dateStr == todayStr) return 'Heute';
    if (dateStr == tomorrowStr) return 'Morgen';

    const weekdays = [
      'Montag',
      'Dienstag',
      'Mittwoch',
      'Donnerstag',
      'Freitag',
      'Samstag',
      'Sonntag',
    ];
    const months = [
      'Jan',
      'Feb',
      'Mär',
      'Apr',
      'Mai',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Okt',
      'Nov',
      'Dez',
    ];
    return '${weekdays[date.weekday - 1]}, ${date.day}. ${months[date.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SliverToBoxAdapter(
        child: SizedBox(height: 400, child: SkeletonListWidget(itemCount: 5)),
      );
    }

    if (appointments.isEmpty) {
      return SliverToBoxAdapter(
        child: EmptyStateWidget(
          iconName: 'calendar_today',
          title: 'Keine Termine vorhanden',
          subtitle: 'Erstelle deinen ersten Termin, um ihn hier zu sehen.',
          actionLabel: 'Termin erstellen',
          onAction: () {},
        ),
      );
    }

    final grouped = _groupByDate();
    final sections = grouped.entries.toList();

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, sectionIndex) {
        final section = sections[sectionIndex];
        final dateLabel = _formatSectionDate(section.key);
        final isToday = dateLabel == 'Heute';
        final items = section.value;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            isTablet ? 24 : 20,
            sectionIndex == 0 ? 0 : 24,
            isTablet ? 24 : 20,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section header
              Row(
                children: [
                  Text(
                    dateLabel,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isToday
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (isToday) ...[
                    const SizedBox(width: 8),
                    StatusBadgeWidget(
                      label: 'Heute',
                      variant: BadgeVariant.primary,
                      compact: true,
                    ),
                  ],
                  const Spacer(),
                  Text(
                    '${items.length} ${items.length == 1 ? 'Termin' : 'Termine'}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Appointment cards — 2-col grid on tablet
              if (isTablet)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.2,
                  ),
                  itemCount: items.length,
                  itemBuilder: (ctx, i) => AppointmentCardWidget(
                    appointment: items[i],
                    animationIndex: i,
                  ),
                )
              else
                Column(
                  children: items
                      .asMap()
                      .entries
                      .map(
                        (e) => Padding(
                          padding: EdgeInsets.only(
                            bottom: e.key < items.length - 1 ? 12 : 0,
                          ),
                          child: AppointmentCardWidget(
                            appointment: e.value,
                            animationIndex: e.key,
                          ),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        );
      }, childCount: sections.length),
    );
  }
}
