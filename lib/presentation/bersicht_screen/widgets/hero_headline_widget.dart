import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

class HeroHeadlineWidget extends StatelessWidget {
  final int todayCount;

  const HeroHeadlineWidget({super.key, required this.todayCount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Du hast ',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                ),
              ),
              TextSpan(
                text: '$todayCount',
                style: theme.textTheme.displayMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        Text(
          todayCount == 1
              ? 'Termin heute'
              : todayCount == 0
              ? 'keine Termine heute'
              : 'Termine heute',
          style: theme.textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(_formatDate(DateTime.now()), style: theme.textTheme.bodyMedium),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const weekdays = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
    const months = [
      'Januar',
      'Februar',
      'März',
      'April',
      'Mai',
      'Juni',
      'Juli',
      'August',
      'September',
      'Oktober',
      'November',
      'Dezember',
    ];
    return '${weekdays[date.weekday - 1]}, ${date.day}. ${months[date.month - 1]} ${date.year}';
  }
}
