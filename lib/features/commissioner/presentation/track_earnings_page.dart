import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TrackEarningsPage extends StatelessWidget {
  const TrackEarningsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Track Earnings',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overview',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 16),
            Row(
              children: const [
                _StatCard(title: 'Earnings', value: 'KES 12,000'),
                SizedBox(width: 12),
                _StatCard(title: 'Bookings', value: '18'),
              ],
            ),
            const SizedBox(height: 12),
            const _StatCard(title: 'Rating', value: '4.6 ⭐'),
            const SizedBox(height: 24),
            const Text(
              'Earnings Over Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
            ),
            const SizedBox(height: 200, child: _EarningsChart()),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
          ],
        ),
      ),
    );
  }
}

class _EarningsChart extends StatelessWidget {
  const _EarningsChart();

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: Colors.blue,
            barWidth: 4,
            dotData: FlDotData(show: false),
            spots: const [
              FlSpot(0, 2),
              FlSpot(1, 2.5),
              FlSpot(2, 3.6),
              FlSpot(3, 2.8),
              FlSpot(4, 4.2),
              FlSpot(5, 3.5),
            ],
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                return Text(months[value.toInt() % months.length], style: const TextStyle(color: Colors.black));
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                return Text('KES ${value.toInt()}k', style: const TextStyle(color: Colors.black));
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
      ),
    );
  }
}
