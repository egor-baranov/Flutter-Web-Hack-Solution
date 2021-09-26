import 'dart:math';

class Employee {
  final int id;
  final String speciality;
  final DateTime birthDate;
  final Gender gender;
  final MaritalStatus isMarried;
  final DateTime startDate;
  final DateTime endDate;
  final String absenceReason;
  final int absenceDays;
  final int salary;
  final String city;
  final int childrenCount;
  final String education;
  int prediction = -1;

  Employee(
      {required this.id,
      required this.speciality,
      required this.birthDate,
      required this.gender,
      required this.isMarried,
      required this.startDate,
      required this.endDate,
      required this.absenceReason,
      required this.absenceDays,
      required this.salary,
      required this.city,
      required this.childrenCount,
      required this.education});

  int workedMonths() {
    return endDate.difference(startDate).inDays ~/ 28 % 50;
  }

  Employee setPrediction(int prediction) {
    this.prediction = prediction;
    return this;
  }

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
        id: int.parse(json['id']),
        speciality: json['speciality'] == "\$speciality"
            ? specialityList[Random().nextInt(20)]
            : json['speciality'],
        birthDate:
            DateTime.parse(json['birthDate'].toString().substring(0, 10)),
        gender: json['gender'] == null
            ? Gender.any
            : json['gender'] == "male"
                ? Gender.male
                : Gender.female,
        isMarried: json['is_married'] == null
            ? MaritalStatus.any
            : json['is_married'] == "true"
                ? MaritalStatus.married
                : MaritalStatus.notMarried,
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(
            json['endDate'] == null ? "2100-01-01" : json['endDate']),
        absenceReason:
            json['absenceReason'] == null ? "" : json['absenceReason'],
        absenceDays: json['absenceDays'] == null ? 0 : json['absenceDays'],
        salary: json['salary'],
        city: json['city'],
        childrenCount: json['childrenCount'],
        education: json['education'] == "higher"
            ? "Высшее"
            : json['education'] == "school"
                ? "Среднее"
                : "Среднее специальное");
  }
}

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

enum Gender { male, female, any }

enum MaritalStatus { married, notMarried, any }
