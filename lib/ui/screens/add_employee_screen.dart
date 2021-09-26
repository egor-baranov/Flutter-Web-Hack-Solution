import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leaders_of_digital_hack/model/employee.dart';
import 'package:leaders_of_digital_hack/util/request_worker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:date_field/date_field.dart';
import 'package:multiselect/multiselect.dart';

class AddEmployeePage extends StatefulWidget {
  @override
  _AddEmployeePageState createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  DateTime startDate = DateTime.parse("2021-01-01"), endDate = DateTime.now();
  bool isGone = true;
  dynamic selectionMode = DateRangePickerSelectionMode.range;
  Gender _gender = Gender.male;
  String cityDropdownValue = 'Москва';
  String educationDropdownValue = 'Высшее';
  String specialityDropdownValue = "Ведущий инженер";
  DateTime? selectedDate;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var specialityList = [
    'Ведущий инженер',
    'Машинист',
    'Инженер',
    'Начальник смены',
    'Заведующий хозяйством',
    'Заместитель начальника отдела',
    'Электрослесарь',
    'Эксперт',
    'Инспектор',
    'Электромонтер ',
    'Главный специалист',
    'Мастер',
    'Старший оператор ',
    'Ведущий специалист',
    'Заместитель главного инженера',
    'Слесарь',
    'Лаборант ',
    'Ведущий экономист',
    'Заместитель директора',
    'Оператор',
    'Заместитель главного бухгалтера',
    'Диспетчер',
    'Кладовщик 3 разряда',
    'Главный бухгалтер',
    'Заместитель начальника цеха',
    'Аппаратчик',
    'Ведущий инструктор',
    'Заточник',
    'Главный инспектор',
    'Главный инженер',
    'Директор',
    'Начальник цеха',
    'Ведущий юрисконсульт',
    'Электрогазосварщик 5 разряда',
    'Заместитель начальника управления',
    'Экономист',
    'Ведущий специалист',
    'Аккумуляторщик ',
    'Электромеханик',
    'Бухгалтер',
    'Ведущий бухгалтер',
    'Электрогазосварщик 6 разряда',
    'Специалист',
    'Токарь',
    'Главный специалист',
    'Фрезеровщик 6 разряда',
    'Водитель автомобиля',
    'Техник',
    'Дежурный',
    'Электрогазосварщик 4 разряда',
    'Ведущий инструктор',
    'Метролог',
    'Шлифовщик 6 разряда',
    'Фрезеровщик 5 разряда',
    'Шлифовщик 5 разряда',
    'Кладовщик 2 разряда',
    'Заведующий складом'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: Center(child: buildUserListCard(context)),
    );
  }

  String getDatePickerLabel() {
    if (isGone) {
      return "Интервал работы в компании\n" +
          "(${startDate.toString().split(" ")[0].split("-").reversed.join(".")} - " +
          "${endDate.toString().split(" ")[0].split("-").reversed.join(".")})";
    }
    return "Дата начала работы в компании\n" +
        "(${startDate.toString().split(" ")[0].split("-").reversed.join(".")})";
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (isGone) {
        startDate = (args.value as PickerDateRange).startDate!;
        endDate = (args.value as PickerDateRange).endDate!;
      } else {
        startDate = (args.value as DateTime);
      }
    });
  }

  Widget buildUserListCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Container(
            height: double.infinity,
            width: 450,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12)],
              borderRadius: new BorderRadius.all(Radius.circular(16.0)),
              shape: BoxShape.rectangle,
              color: Theme.of(context).dialogBackgroundColor,
            ),
            child: IntrinsicHeight(
              child: SingleChildScrollView(
                child: Column(children: [
                  SizedBox(height: 24),
                  Text(
                    "Добавление сотрудника",
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 48),
                  SizedBox(
                    width: 350,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'ID',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  SizedBox(height: 48),
                  SizedBox(
                    width: 350,
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Заработанная плата',
                          suffixText: 'руб.'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  SizedBox(height: 48),
                  SizedBox(
                    width: 350,
                    child: DateTimeFormField(
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.black45),
                        errorStyle: TextStyle(color: Colors.redAccent),
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.event_note),
                        labelText: 'Дата рождения',
                      ),
                      mode: DateTimeFieldPickerMode.date,
                      autovalidateMode: AutovalidateMode.always,
                      onDateSelected: (DateTime value) {
                        print(value);
                      },
                    ),
                  ),
                  SizedBox(height: 24),
                  Text("Должность",
                      style: Theme.of(context).textTheme.headline6),
                  SizedBox(height: 24),
                  SizedBox(
                    width: 350,
                    child: DropdownButtonFormField<String>(
                      value: specialityDropdownValue,
                      elevation: 16,
                      onChanged: (String? newValue) {
                        setState(() {
                          specialityDropdownValue = newValue!;
                        });
                      },
                      items: specialityList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 48),
                  SizedBox(
                    width: 350,
                    child: DateTimeFormField(
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.black45),
                        errorStyle: TextStyle(color: Colors.redAccent),
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.event_note),
                        labelText: 'Дата начала работы',
                      ),
                      mode: DateTimeFieldPickerMode.date,
                      autovalidateMode: AutovalidateMode.always,
                      onDateSelected: (DateTime value) {
                        print(value);
                      },
                    ),
                  ),
                  SizedBox(height: 48),
                  SizedBox(
                    width: 350,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Количество детей',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  SizedBox(height: 36),
                  Text("Пол", style: Theme.of(context).textTheme.headline6),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 48.0, right: 48.0),
                    child: Row(children: [
                      Expanded(
                        flex: 1,
                        child: ListTile(
                          title: const Text('Мужской'),
                          leading: Radio<Gender>(
                            value: Gender.male,
                            groupValue: _gender,
                            onChanged: (Gender? value) {
                              setState(() {
                                _gender = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: ListTile(
                          title: const Text('Женский'),
                          leading: Radio<Gender>(
                            value: Gender.female,
                            groupValue: _gender,
                            onChanged: (Gender? value) {
                              setState(() {
                                _gender = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ]),
                  ),
                  SizedBox(height: 36),
                  Text("Город", style: Theme.of(context).textTheme.headline6),
                  SizedBox(height: 24),
                  SizedBox(
                    width: 350,
                    child: DropdownButtonFormField<String>(
                      value: cityDropdownValue,
                      elevation: 16,
                      onChanged: (String? newValue) {
                        setState(() {
                          cityDropdownValue = newValue!;
                        });
                      },
                      items: <String>[
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
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 48),
                  Text("Образование",
                      style: Theme.of(context).textTheme.headline6),
                  SizedBox(height: 24),
                  SizedBox(
                    width: 350,
                    child: DropdownButtonFormField<String>(
                      value: educationDropdownValue,
                      elevation: 16,
                      onChanged: (String? newValue) {
                        setState(() {
                          educationDropdownValue = newValue!;
                        });
                      },
                      items: <String>['Высшее', 'Среднее специальное', 'Средне']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 48),
                  Text("Отсутствие в учетном периоде",
                      style: Theme.of(context).textTheme.headline6),
                  SizedBox(
                    width: 350,
                    child: DropDownMultiSelect(
                      onChanged: (List<String> x) {},
                      options: [
                        'Отпуск',
                        'Командировка',
                        'Лист нетрудоспособности',
                        'Прочие причины'
                      ],
                      selectedValues: [],
                      whenEmpty: 'Причины отсутствия',
                    ),
                  ),
                  SizedBox(
                    width: 350,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Дни отсутствия',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: 240,
                    child: CheckboxListTile(
                      title: Text("Сотрудник уволился"),
                      checkColor: Colors.white,
                      tileColor: Theme.of(context).accentColor,
                      value: isGone,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool? value) {
                        setState(() {
                          isGone = value!;
                          if (isGone) {
                            selectionMode = DateRangePickerSelectionMode.range;
                          } else {
                            selectionMode = DateRangePickerSelectionMode.single;
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 24),
                  Visibility(
                      child: Center(
                          child: Column(
                        children: [
                          SizedBox(
                            width: 350,
                            child: DateTimeFormField(
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Colors.black45),
                                errorStyle: TextStyle(color: Colors.redAccent),
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.event_note),
                                labelText: 'Дата увольнения',
                              ),
                              mode: DateTimeFieldPickerMode.date,
                              autovalidateMode: AutovalidateMode.always,
                              onDateSelected: (DateTime value) {
                                print(value);
                              },
                            ),
                          ),
                          SizedBox(height: 24),
                        ],
                      )),
                      visible: isGone),
                  SizedBox(height: 24),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(),
                      onPressed: () {
                        _scaffoldKey.currentState!.showSnackBar(new SnackBar(
                          duration: new Duration(seconds: 4),
                          content: new Row(
                            children: <Widget>[
                              new CircularProgressIndicator(),
                              new Text("    Вносим данные сотрудника в базу...")
                            ],
                          ),
                        ));
                        setState(() {
                          RequestWorker.addEmployeeData();
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            SystemNavigator.pop();
                          }
                        });
                      },
                      child: Text("Добавить"),
                    ),
                  )
                ]),
              ),
            )),
      ),
    );
  }
}
