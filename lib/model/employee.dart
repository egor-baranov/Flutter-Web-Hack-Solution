class Employee {
  final int id;
  final String speciality;
  final DateTime birthDate;
  final String gender;
  final bool isMarried;
  final DateTime startDate;
  final DateTime endDate;
  final String absenceReason;
  final int absenceDays;
  final int salary;
  final String city;
  final int childrenCount;

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
      required this.childrenCount});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
        id: json['id'],
        speciality: json['speciality'],
        birthDate: json['birthDate'],
        gender: json['gender'],
        isMarried: json['isMarried'],
        startDate: json['startDate'],
        endDate: json['endDate'],
        absenceReason: json['absenceReason'],
        absenceDays: json['absenceDays'],
        salary: json['salary'],
        city: json['city'],
        childrenCount: json['childrenCount']);
  }
}

enum Gender { male, female, any }

enum MaritalStatus { married, notMarried, any }
