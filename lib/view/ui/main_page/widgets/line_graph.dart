import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineGraph extends StatelessWidget {
  const LineGraph(this.data, {Key? key}) : super(key: key);

  final List<int> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.only(top: 12, bottom: 5, left: 5),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: AspectRatio(
        aspectRatio: 1.8,
        child: LineChart(
          mainData(context),
        ),
      ),
    );
  }

  LineChartData mainData(BuildContext context) {
    return LineChartData(
      minX: 0,
      maxX: data.length.toDouble(),
      minY: 0,
      maxY: data.reduce(max).toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(data.length, (index) {
            return FlSpot(index.toDouble(), data[index].toDouble());
          }).toList(),
          // isCurved: true,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
      ],
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
            strokeWidth: 0.25,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
            strokeWidth: 0.25,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: false,
      ),
      borderData: FlBorderData(
        show: false,
      ),
    );
  }
}
