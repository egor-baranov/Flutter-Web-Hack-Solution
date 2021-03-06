import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:leaders_of_digital_hack/model/employee.dart';

class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {this.animate = false});

  /// Creates a [BarChart] with sample data and no transition.
  factory SimpleBarChart.withSampleData(List<Employee> list) {
    return new SimpleBarChart(
      _createSampleData(list),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      List.from(seriesList),
      animate: animate,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData(
      List<Employee> list) {

    print(list);
    list.sort((a, b) => a.birthDate.compareTo(b.birthDate));
    var data = <OrdinalSales>[];

    if (list.length < 4) {
      data = [
        new OrdinalSales('2014', Random().nextInt(100)),
        new OrdinalSales('2015', Random().nextInt(100)),
        new OrdinalSales('2016', Random().nextInt(100)),
        new OrdinalSales('2017', Random().nextInt(100))
      ];
    } else {
      list.shuffle();
      list = list.take(10).toList();
      list.sort((a, b) => a.birthDate.compareTo(b.birthDate));
      data = list
          .map((e) => new OrdinalSales(
          e.birthDate.toString().split(" ")[0].split("-")[0],
          e.prediction)).toList();
    }

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
