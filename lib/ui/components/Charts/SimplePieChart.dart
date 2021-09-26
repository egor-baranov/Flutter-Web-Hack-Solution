import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:leaders_of_digital_hack/model/employee.dart';

class PieOutsideLabelChart extends StatelessWidget {
  final List<charts.Series<LinearSales, int>> seriesList;
  final bool? animate;

  PieOutsideLabelChart(this.seriesList, {this.animate = false});

  /// Creates a [PieChart] with sample data and no transition.
  factory PieOutsideLabelChart.withSampleData(List<Employee> list) {
    return new PieOutsideLabelChart(
      _createSampleData(list),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart<int>(
      seriesList,
      animate: animate,
      // Configure the width of the pie slices to 60px. The remaining space in
      // the chart will be left as a hole in the center.
        defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [
          new charts.ArcLabelDecorator(
              labelPosition: charts.ArcLabelPosition.outside)
        ]));
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData(List<Employee> list) {
    // final data = new List<int>.generate(list.length - 1, (i) => i + 1)
    //     .map((e) => new LinearSales(e, list[e].prediction))
    //     .toList();

    final data = [
      new LinearSales(0, Random().nextInt(100)),
      new LinearSales(1, Random().nextInt(100)),
      new LinearSales(2, Random().nextInt(100)),
      new LinearSales(3, Random().nextInt(100)),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
        labelAccessorFn: (LinearSales row, _) => '${row.year}: ${row.sales}',
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