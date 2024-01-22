import 'package:emp_management_ansh_ramani/database.dart';
import 'package:emp_management_ansh_ramani/model/employee_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeBloc extends Cubit<List<Employee>> {
  final dbHelper = DatabaseHelper();

  EmployeeBloc() : super([]);

  // Fetch employees from the database and update the state.
  void getEmployees() async {
    final employees = await dbHelper.getEmployees();
    emit(employees);
  }

  // Insert an employee into the database.
  void addEmployee(Employee employee) async {
    await dbHelper.insertEmployee(employee);
    getEmployees(); // Refresh the list of employees.
  }
}
