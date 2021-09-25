import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leaders_of_digital_hack/ui/components/Charts/PointsLineChart.dart';
import 'package:leaders_of_digital_hack/ui/components/Charts/SimpleBarChart.dart';
import 'package:leaders_of_digital_hack/model/employee.dart';
import 'package:leaders_of_digital_hack/ui/components/Charts/SimplePieChart.dart';
import 'package:leaders_of_digital_hack/ui/components/sidebar.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:leaders_of_digital_hack/util/request_worker.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:multiselect/multiselect.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expandable/expandable.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/src/painting/basic_types.dart' as basicTypes;

import 'add_employee_screen.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isMarriedChecked = false;
  RangeValues _salaryRangeValues = const RangeValues(40000, 80000);
  RangeValues _childrenRangeValues = const RangeValues(0, 10);
  Gender _gender = Gender.any;
  MaritalStatus _maritalStatus = MaritalStatus.any;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var rows = List<DataRow>.generate(
    20,
    (index) => DataRow(
      cells: <DataCell>[
        DataCell(Text(Random().nextInt(100000).toString())),
        DataCell(Text(Random().nextInt(13).toString() + ' мес.')),
        DataCell(Text(Random().nextInt(300).toString() + ' тыс. руб.')),
        DataCell(Text([
          "Спб",
          "Москва",
          "Мытищи",
          "Сызрань",
          "Щелково"
        ][Random().nextInt(5)])),
        DataCell(Text([
          "Высшее",
          "Среднее",
          "Школа",
        ][Random().nextInt(3)])),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Column(
              children: <Widget>[
                // Expanded(flex: 1, child: buildDashboardHeader(context)),
                Expanded(
                  flex: 9,
                  child: Row(
                    children: <Widget>[
                      // Expanded(flex: 2, child: Sidebar()),
                      Expanded(flex: 4, child: buildFilterCard(context)),
                      Expanded(
                        flex: 14,
                        child: buildDashboardContent(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // buildFloatingSearchBar(context)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Добавить сотрудника"),
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).accentColor,
        onPressed: () => Navigator.push(
          context,
          _createRoute(),
        ),
      ),
    );
  }

  Widget buildDashboardHeader(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      child: Center(
        child: Text(
          "Dashboard Header",
          style: GoogleFonts.montserrat(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12)],
        shape: BoxShape.rectangle,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }

  Widget buildDashboardContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(children: [
        Expanded(flex: 1, child: buildUserListCard(context)),
        SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child:
                      buildGraphCard(context, SimpleBarChart.withSampleData())),
              SizedBox(height: 16),
              Expanded(
                  flex: 1,
                  child: buildGraphCard(
                      context, PointsLineChart.withSampleData())),
              SizedBox(height: 16),
              Expanded(
                  flex: 1,
                  child: buildGraphCard(
                      context, PieOutsideLabelChart.withSampleData()))
            ],
          ),
        )
      ]),
    );
  }

  Widget buildUserListCard(BuildContext context) {
    return Center(
      child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12)],
            borderRadius: new BorderRadius.all(Radius.circular(16.0)),
            shape: BoxShape.rectangle,
            color: Theme.of(context).dialogBackgroundColor,
          ),
          child: IntrinsicHeight(
            child: SingleChildScrollView(
              scrollDirection: basicTypes.Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: basicTypes.Axis.vertical,
                child: Column(children: [
                  Text(
                    "Список сотрудников",
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 48),
                  DataTable(columns: <DataColumn>[
                    DataColumn(
                      label: Text('ID'),
                    ),
                    DataColumn(
                      label: Text('Работал'),
                    ),
                    DataColumn(
                      label: Text('Зарплата'),
                    ),
                    DataColumn(
                      label: Text('Город'),
                    ),
                    DataColumn(label: Text('Образование'))
                  ], rows: rows),
                ]),
              ),
            ),
          )),
    );
  }

  Widget buildUserItem(BuildContext context, String text) {
    return SizedBox(
      height: 160,
      child: ExpandablePanel(
        header: Center(
          child: Text(
            text,
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        collapsed: SizedBox(height: 32),
        expanded: SizedBox(
          height: 80,
          width: double.infinity,
          child: Center(
            child: Text(
              "A Flutter widget that can be expanded or collapsed by the user. \n" +
                  "Introduction #. \n" +
                  "This library helps implement expandable behavior as prescribed ...",
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFilterCard(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12)],
          borderRadius: new BorderRadius.all(Radius.circular(0.0)),
          shape: BoxShape.rectangle,
          color: Theme.of(context).dialogBackgroundColor,
        ),
        child: SingleChildScrollView(
          child: Column(children: [
            Text(
              "Фильтры",
              style: GoogleFonts.montserrat(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 48),
            Text(
              "Город работы",
              style: Theme.of(context).textTheme.headline6,
            ),
            DropDownMultiSelect(
              onChanged: (List<String> x) {},
              options: ['Москва', 'Санкт-Петербург', 'Щёлково', 'Казань'],
              selectedValues: [],
              whenEmpty: 'Выберите город',
            ),
            Text(
              "Образование",
              style: Theme.of(context).textTheme.headline6,
            ),
            DropDownMultiSelect(
              onChanged: (List<String> x) {},
              options: ['Высшее', 'Среднее специальное', 'Среднее'],
              selectedValues: [],
              whenEmpty: 'Выберите образование',
            ),
            SizedBox(height: 8),
            Text(
              "Интервал работы в компании",
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 24),
            SizedBox(
              width: 350,
              child: DateTimeFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.event_note),
                  labelText: 'Начало работы не раньше',
                ),
                mode: DateTimeFieldPickerMode.date,
                autovalidateMode: AutovalidateMode.always,
                onDateSelected: (DateTime value) {
                  print(value);
                },
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 350,
              child: DateTimeFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.event_note),
                  labelText: 'Увольнение не позже',
                ),
                mode: DateTimeFieldPickerMode.date,
                autovalidateMode: AutovalidateMode.always,
                onDateSelected: (DateTime value) {
                  print(value);
                },
              ),
            ),
            SizedBox(height: 36),
            Row(children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text("Пол",
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center),
                    SizedBox(height: 16),
                    Column(children: [
                      ListTile(
                        title: const Text('Мужской'),
                        leading: Radio<Gender>(
                          value: Gender.male,
                          groupValue: _gender,
                          onChanged: (Gender? value) {
                            setState(() {
                              _gender = Gender.male;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Женский'),
                        leading: Radio<Gender>(
                          value: Gender.female,
                          groupValue: _gender,
                          onChanged: (Gender? value) {
                            setState(() {
                              _gender = Gender.female;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Любой'),
                        leading: Radio<Gender>(
                          value: Gender.any,
                          groupValue: _gender,
                          onChanged: (Gender? value) {
                            setState(() {
                              _gender = Gender.any;
                            });
                          },
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      "Семейное положение",
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Column(children: [
                      ListTile(
                        title: const Text('В браке'),
                        leading: Radio<MaritalStatus>(
                          value: MaritalStatus.married,
                          groupValue: _maritalStatus,
                          onChanged: (MaritalStatus? value) {
                            setState(() {
                              _maritalStatus = MaritalStatus.married;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Не в браке'),
                        leading: Radio<MaritalStatus>(
                          value: MaritalStatus.notMarried,
                          groupValue: _maritalStatus,
                          onChanged: (MaritalStatus? value) {
                            setState(() {
                              _maritalStatus = MaritalStatus.notMarried;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Не важно'),
                        leading: Radio<MaritalStatus>(
                          value: MaritalStatus.any,
                          groupValue: _maritalStatus,
                          onChanged: (MaritalStatus? value) {
                            setState(() {
                              _maritalStatus = MaritalStatus.any;
                            });
                          },
                        ),
                      ),
                    ]),
                  ],
                ),
              )
            ]),
            SizedBox(height: 32),
            Text(
              "Заработанная плата",
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 350,
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'От',
                    suffixText: 'руб.'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 350,
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'До',
                    suffixText: 'руб.'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            SizedBox(height: 32),
            Text(
              "Количество детей",
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 0,
                  child: Text((_childrenRangeValues.start).toString()),
                ),
                Expanded(
                  flex: 6,
                  child: RangeSlider(
                    values: _childrenRangeValues,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    labels: RangeLabels(
                      _childrenRangeValues.start.round().toString(),
                      _childrenRangeValues.end.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _childrenRangeValues = values;
                      });
                    },
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Text((_childrenRangeValues.end).toString()),
                ),
              ],
            ),
            SizedBox(height: 50),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(),
                onPressed: () async {
                  _scaffoldKey.currentState!.showSnackBar(new SnackBar(
                    duration: new Duration(seconds: 4),
                    content: new Row(
                      children: <Widget>[
                        new CircularProgressIndicator(),
                        new Text("    Загружаем данные...")
                      ],
                    ),
                  ));
                  Future.delayed(const Duration(milliseconds: 2000), () {
                    setState(() {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        SystemNavigator.pop();
                      }
                    });
                  });

                  RequestWorker.fetchFiltered();
                },
                child: Text("Применить"),
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget buildGraphCard(BuildContext context, Widget graph) {
    return Center(
      child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12)],
            borderRadius: new BorderRadius.all(Radius.circular(16.0)),
            shape: BoxShape.rectangle,
            color: Theme.of(context).dialogBackgroundColor,
          ),
          child: graph),
    );
  }

  Widget buildFloatingSearchBar(BuildContext context) {
    return FloatingSearchBar(
      hint: 'Search employees..',
      automaticallyImplyDrawerHamburger: false,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 400),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: 0.9,
      openAxisAlignment: 0.9,
      width: 300,
      debounceDelay: const Duration(milliseconds: 250),
      onQueryChanged: (query) {
        // Call your model, bloc, controller here.
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: ["1", "2", "3", "4", "5"].map((text) {
                return Center(
                  child: Container(
                    width: double.infinity,
                    height: 64,
                    child: TextButton(
                      child: Text("Employee " + text),
                      onPressed: () {},
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => AddEmployeePage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

class SalesData {
  SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
