class Employee {
  int? id;
  String? name;
  String? role;
  String? dateOfEmployment;

  Employee({this.id, this.name, this.role, this.dateOfEmployment});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'dateOfEmployment': dateOfEmployment,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      role: map['role'],
      dateOfEmployment: map['dateOfEmployment'],
    );
  }
}

