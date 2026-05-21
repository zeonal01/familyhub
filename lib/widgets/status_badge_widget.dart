import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum BadgeVariant { success, warning, error, info, neutral, primary }

class StatusBadgeWidget extends StatelessWidget {
  final String label;
  final BadgeVariant variant;
  final bool compact;

  const StatusBadgeWidget({
    super.key,
    required this.label,
    this.variant = BadgeVariant.neutral,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _resolveColors(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.$2, width: 1),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: compact ? 10 : 11,
          fontWeight: FontWeight.w600,
          color: colors.$3,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  (Color, Color, Color) _resolveColors(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (variant) {
      case BadgeVariant.success:
        return isDark
            ? (
                const Color(0xFF1A3A2A),
                const Color(0xFF2D9E5F),
                const Color(0xFF4ADE80),
              )
            : (
                const Color(0xFFD1FAE5),
                const Color(0xFF2D9E5F),
                const Color(0xFF166534),
              );
      case BadgeVariant.warning:
        return isDark
            ? (
                const Color(0xFF3A2A0A),
                const Color(0xFFE6A817),
                const Color(0xFFFBBF24),
              )
            : (
                const Color(0xFFFEF3C7),
                const Color(0xFFE6A817),
                const Color(0xFF92400E),
              );
      case BadgeVariant.error:
        return isDark
            ? (
                const Color(0xFF3A1A1A),
                const Color(0xFFD32F2F),
                const Color(0xFFFC8181),
              )
            : (
                const Color(0xFFFFEBEE),
                const Color(0xFFD32F2F),
                const Color(0xFF7F1D1D),
              );
      case BadgeVariant.info:
        return isDark
            ? (
                const Color(0xFF1A2A3A),
                const Color(0xFF3B82F6),
                const Color(0xFF60A5FA),
              )
            : (
                const Color(0xFFEFF6FF),
                const Color(0xFF3B82F6),
                const Color(0xFF1E40AF),
              );
      case BadgeVariant.primary:
        return isDark
            ? (
                const Color(0xFF1A2060),
                const Color(0xFF8B9EFF),
                const Color(0xFF8B9EFF),
              )
            : (
                const Color(0xFFDDE3FF),
                const Color(0xFF3B5BDB),
                const Color(0xFF1E3A8A),
              );
      case BadgeVariant.neutral:
        return isDark
            ? (
                const Color(0xFF2A2A3E),
                const Color(0xFF4A4A6A),
                const Color(0xFFB0B0C8),
              )
            : (
                const Color(0xFFF4F6FB),
                const Color(0xFFBDBDBD),
                const Color(0xFF4A4A6A),
              );
    }
  }
}
