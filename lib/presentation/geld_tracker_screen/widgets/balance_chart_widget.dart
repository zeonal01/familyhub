import 'package:fl_chart/fl_chart.dart';
import '../../../core/app_export.dart';

class BalanceChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> bookings;

  const BalanceChartWidget({super.key, required this.bookings});

  List<FlSpot> _buildSpots() {
    double running = 0;
    final spots = <FlSpot>[];
    final sorted = List<Map<String, dynamic>>.from(bookings)
      ..sort((a, b) => (a['date'] as String).compareTo(b['date'] as String));

    for (int i = 0; i < sorted.length; i++) {
      running += (sorted[i]['amount'] as num).toDouble();
      spots.add(FlSpot(i.toDouble(), running));
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final spots = _buildSpots();

    if (spots.isEmpty) return const SizedBox.shrink();

    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY).abs() * 0.15 + 10;

    return SizedBox(
      height: 100,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (spots.length - 1).toDouble(),
          minY: minY - padding,
          maxY: maxY + padding,
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: (maxY - minY).abs() / 3 + 1,
            getDrawingHorizontalLine: (_) => FlLine(
              color: theme.colorScheme.outlineVariant,
              strokeWidth: 1,
              dashArray: [4, 4],
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: theme.colorScheme.inverseSurface,
              tooltipRoundedRadius: 8,
              getTooltipItems: (spots) => spots
                  .map(
                    (s) => LineTooltipItem(
                      '${s.y >= 0 ? '+' : ''}${s.y.toStringAsFixed(2)} €',
                      GoogleFonts.dmSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onInverseSurface,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.3,
              color: primary,
              barWidth: 2.5,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
                  radius: 3,
                  color: primary,
                  strokeWidth: 1.5,
                  strokeColor: theme.colorScheme.surface,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [primary.withAlpha(51), primary.withAlpha(0)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}