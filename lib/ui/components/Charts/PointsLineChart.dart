import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class PointsLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  PointsLineChart(this.seriesList, {this.animate = true});

  /// Creates a [LineChart] with sample data and no transition.
  factory PointsLineChart.withSampleData(List<int> data) {
    return new PointsLineChart(
      _createSampleData(data),
      // Disable animations for image tests.
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(List.from(seriesList),
        animate: animate,
        defaultRenderer: new charts.LineRendererConfig(includePoints: true));
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData(List<int> list) {
    print(list);

    var data = [
      new LinearSales(0, Random().nextInt(100)),
      new LinearSales(1, Random().nextInt(100)),
      new LinearSales(2, Random().nextInt(100)),
      new LinearSales(3, Random().nextInt(100)),
    ];

    if(list.length >= 4) {
    data = new List<int>.generate(list.length - 1, (i) => i + 1)
        .map((e) => new LinearSales(e, list[e] % 100)).take(10).toList();
    }

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
