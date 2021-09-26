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
  RangeValues _childrenRangeValues = const RangeValues(0, 10);
  RangeValues _salaryRangeValues = RangeValues(0, 30000001);
  Gender _gender = Gender.any;
  bool ascending = false;
  int sortColumnIndex = 0;

  MaritalStatus _maritalStatus = MaritalStatus.any;
  List<String> educations = ["Высшее"], cities = ["Москва"];
  DateTime startDate = DateTime.parse("1900-01-01"),
      endDate = DateTime.parse("2100-01-01");

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var employees = <Employee>[];

  Future<void> updateRows() async {
    var employeeList = await RequestWorker.fetchFiltered(
      ['Москва'],
      _gender,
      RangeValues(
        _childrenRangeValues.start,
        _childrenRangeValues.end,
      ),
      _maritalStatus,
      _salaryRangeValues,
      cities,
      educations,
      startDate,
      endDate,
    );
    employeeList.shuffle();
    employeeList = employeeList.sublist(0, min(100, employeeList.length));
    print("EmployeeList: $employeeList");

    setState(() {
      employees = employeeList;
    });
  }

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
                      buildGraphCard(context, SimpleBarChart.withSampleData(employees))),
              SizedBox(height: 16),
              Expanded(
                  flex: 1,
                  child: buildGraphCard(
                      context,
                      PointsLineChart.withSampleData(
                          employees.map((e) => e.prediction).toList()))),
              SizedBox(height: 16),
              Expanded(
                  flex: 1,
                  child: buildGraphCard(
                      context, PieOutsideLabelChart.withSampleData(employees)))
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
            child: Column(
              children: [
                Text(
                  "Список сотрудников",
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: basicTypes.Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: basicTypes.Axis.vertical,
                      child: Column(children: [
                        DataTable(
                            sortAscending: ascending,
                            sortColumnIndex: sortColumnIndex,
                            columns: <DataColumn>[
                              DataColumn(
                                label: Text('ID'),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    this.sortColumnIndex = columnIndex;
                                    this.ascending = ascending;
                                    if (this.ascending) {
                                      employees
                                          .sort((a, b) => a.id.compareTo(b.id));
                                    } else {
                                      employees
                                          .sort((a, b) => b.id.compareTo(a.id));
                                    }
                                  });
                                },
                              ),
                              DataColumn(
                                label: Text('Оставшееся\nвремя в компании'),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    this.sortColumnIndex = columnIndex;
                                    this.ascending = ascending;
                                    if (this.ascending) {
                                      employees.sort((a, b) =>
                                          a.prediction.compareTo(b.prediction));
                                    } else {
                                      employees.sort((a, b) =>
                                          b.prediction.compareTo(a.prediction));
                                    }
                                  });
                                },
                              ),
                              DataColumn(
                                label: Text('Должность'),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    this.sortColumnIndex = columnIndex;
                                    this.ascending = ascending;
                                    if (this.ascending) {
                                      employees.sort((a, b) =>
                                          a.speciality.compareTo(b.speciality));
                                    } else {
                                      employees.sort((a, b) =>
                                          b.speciality.compareTo(a.speciality));
                                    }
                                  });
                                },
                              ),
                              DataColumn(
                                label: Text('Стаж в \nкомпании'),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    this.sortColumnIndex = columnIndex;
                                    this.ascending = ascending;
                                    if (this.ascending) {
                                      employees.sort((a, b) => a
                                          .workedMonths()
                                          .compareTo(b.workedMonths()));
                                    } else {
                                      employees.sort((a, b) => b
                                          .workedMonths()
                                          .compareTo(a.workedMonths()));
                                    }
                                  });
                                },
                              ),
                              DataColumn(
                                label: Text('Оклад'),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    this.sortColumnIndex = columnIndex;
                                    this.ascending = ascending;
                                    if (this.ascending) {
                                      employees.sort((a, b) =>
                                          a.salary.compareTo(b.salary));
                                    } else {
                                      employees.sort((a, b) =>
                                          b.salary.compareTo(a.salary));
                                    }
                                  });
                                },
                              ),
                              DataColumn(
                                label: Text('Город'),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    this.sortColumnIndex = columnIndex;
                                    this.ascending = ascending;
                                    if (this.ascending) {
                                      employees.sort(
                                          (a, b) => a.city.compareTo(b.city));
                                    } else {
                                      employees.sort(
                                          (a, b) => b.city.compareTo(a.city));
                                    }
                                  });
                                },
                              ),
                              DataColumn(
                                label: Text('Образование'),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    this.sortColumnIndex = columnIndex;
                                    this.ascending = ascending;
                                    if (this.ascending) {
                                      employees.sort((a, b) =>
                                          a.education.compareTo(b.education));
                                    } else {
                                      employees.sort((a, b) =>
                                          b.education.compareTo(a.education));
                                    }
                                  });
                                },
                              ),
                              DataColumn(
                                label: Text('Пол'),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    this.sortColumnIndex = columnIndex;
                                    this.ascending = ascending;
                                    if (this.ascending) {
                                      employees.sort((a, b) => a.gender
                                          .toString()
                                          .compareTo(b.gender.toString()));
                                    } else {
                                      employees.sort((a, b) => b.gender
                                          .toString()
                                          .compareTo(a.gender.toString()));
                                    }
                                  });
                                },
                              ),
                              DataColumn(
                                label: Text('Дата рождения'),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    this.sortColumnIndex = columnIndex;
                                    this.ascending = ascending;
                                    if (this.ascending) {
                                      employees.sort((a, b) =>
                                          a.birthDate.compareTo(b.birthDate));
                                    } else {
                                      employees.sort((a, b) =>
                                          b.birthDate.compareTo(a.birthDate));
                                    }
                                  });
                                },
                              ),
                              DataColumn(
                                label: Text('Дни отсутствия'),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    this.sortColumnIndex = columnIndex;
                                    this.ascending = ascending;
                                    if (this.ascending) {
                                      employees.sort((a, b) => a.absenceDays
                                          .compareTo(b.absenceDays));
                                    } else {
                                      employees.sort((a, b) => b.absenceDays
                                          .compareTo(a.absenceDays));
                                    }
                                  });
                                },
                              ),
                              DataColumn(
                                label: Text('Количество детей'),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    this.sortColumnIndex = columnIndex;
                                    this.ascending = ascending;
                                    if (this.ascending) {
                                      employees.sort((a, b) => a.childrenCount
                                          .compareTo(b.childrenCount));
                                    } else {
                                      employees.sort((a, b) => b.childrenCount
                                          .compareTo(a.childrenCount));
                                    }
                                  });
                                },
                              )
                            ],
                            rows: employees
                                .map(
                                  (item) => DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(item.id.toString())),
                                      DataCell(Text(
                                          (item.prediction ~/ 28).toString() +
                                              " мес.")),
                                      DataCell(Text(item.speciality)),
                                      DataCell(
                                          Text('${item.workedMonths()} мес.')),
                                      DataCell(Text(
                                          item.salary.toString() + ' руб.')),
                                      DataCell(Text(item.city)),
                                      DataCell(Text(item.education)),
                                      DataCell(Text(item.gender == Gender.male
                                          ? "Мужской"
                                          : "Женский")),
                                      DataCell(Text(item.birthDate
                                          .toString()
                                          .split(" ")[0]
                                          .split("-")
                                          .reversed
                                          .join("."))),
                                      DataCell(
                                          Text(item.absenceDays.toString())),
                                      DataCell(
                                          Text(item.childrenCount.toString()))
                                    ],
                                  ),
                                )
                                .toList()),
                      ]),
                    ),
                  ),
                ),
              ],
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
              onChanged: (List<String> x) {
                cities = x;
              },
              options: [
                'Москва',
                'Щербинка',
                'Обнинск',
                'Саратов',
                'Пенза',
                'Новоросийск',
                'Омск',
                'Смоленск',
                'Иваново',
                'Белгород',
                'Шиханы',
                'Кузнецк',
                'Кандалакша'
              ],
              selectedValues: cities,
              whenEmpty: 'Выберите город',
            ),
            Text(
              "Образование",
              style: Theme.of(context).textTheme.headline6,
            ),
            DropDownMultiSelect(
              onChanged: (List<String> x) {
                educations = x;
              },
              options: ['Высшее', 'Среднее специальное', 'Среднее'],
              selectedValues: educations,
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
                  startDate = value;
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
                  endDate = value;
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
                onChanged: (text) {
                  _salaryRangeValues = RangeValues(
                    int.parse(text.isEmpty ? "0" : text).toDouble(),
                    _salaryRangeValues.end,
                  );
                },
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
                onChanged: (text) {
                  _salaryRangeValues = RangeValues(
                    _salaryRangeValues.start,
                    int.parse(text.isEmpty ? "300000001" : text).toDouble(),
                  );
                },
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
                  setState(() {
                    updateRows();
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      SystemNavigator.pop();
                    }
                  });
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
