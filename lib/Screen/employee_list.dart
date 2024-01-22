// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:developer';

import 'package:emp_management_ansh_ramani/Controller/employee.dart';
import 'package:emp_management_ansh_ramani/Screen/add_employee_details.dart';
import 'package:emp_management_ansh_ramani/database.dart';
import 'package:emp_management_ansh_ramani/model/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Employee List'),
      ),
      body: BlocBuilder<EmployeeBloc, List<Employee>>(
        builder: (context, employeeList) {
          log("employeeList $employeeList");
          List<Employee> previousEmployee = [];
          List<Employee> currentEmployee = [];
          employeeList.forEach((element) {
            log("dateOfEmployment ${element.dateOfEmployment}");
            // if (DateTime.parse(element.dateOfEmployment.toString().split("|").last).millisecondsSinceEpoch < DateTime.now().millisecondsSinceEpoch) {
            if (element.dateOfEmployment.toString().split("|").last != null && element.dateOfEmployment.toString().split("|").last.isNotEmpty) {
              previousEmployee.add(element);
            } else {
              currentEmployee.add(element);
            }
          });
          return employeeList.isEmpty
              ? SvgPicture.asset(
                  'assets/no_item.svg',
                  width: 261.79,
                  height: 244.38,
                ).centered()
              : Column(
                  children: [
                    currentEmployee.isEmpty
                        ? const SizedBox()
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(16),
                            decoration:
                                BoxDecoration(color: Colors.grey.shade100),
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Current employees",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                          ),
                    currentEmployee.isEmpty
                        ? const SizedBox()
                        : ListView.builder(
                            shrinkWrap: true,
                            // itemCount: employeeList.length,
                            itemCount: currentEmployee.length,
                            itemBuilder: (context, index) {
                              // final employee = employeeList[index];
                              final employee = currentEmployee[index];
                              return Slidable(
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      padding: EdgeInsets.zero,
                                      onPressed: (context) {
                                        deleteEmployee(index, employeeList);
                                        // employeeList.removeAt(index);
                                        setState(() {});
                                      },
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete_outline,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        _navigateToUpdatePage(employee);
                                      },
                                      title: employee.name!.text
                                          .size(16)
                                          .medium
                                          .make(),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          employee.role!.text
                                              .size(14)
                                              .normal
                                              .make(),
                                          6.heightBox,
                                          Text(
                                              "From ${DateFormat('dd MMM, yy').format(DateTime.parse(employee.dateOfEmployment!.toString().split("|").first))}"),
                                        ],
                                      ),
                                    ),
                                    const Divider(height: 0),
                                  ],
                                ),
                              );
                            },
                          ),
                    previousEmployee.isEmpty
                        ? const SizedBox()
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(16),
                            decoration:
                                BoxDecoration(color: Colors.grey.shade100),
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Previous employees",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                          ),
                    previousEmployee.isEmpty
                        ? const SizedBox()
                        : ListView.builder(
                            shrinkWrap: true,
                            // itemCount: employeeList.length,
                            itemCount: previousEmployee.length,
                            itemBuilder: (context, index) {
                              // final employee = employeeList[index];
                              final employee = previousEmployee[index];
                              return Slidable(
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      padding: EdgeInsets.zero,
                                      onPressed: (context) {
                                        deleteEmployee(index, employeeList);
                                        // employeeList.removeAt(index);
                                        setState(() {});
                                      },
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete_outline,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        _navigateToUpdatePage(employee);
                                      },
                                      title: employee.name!.text
                                          .size(16)
                                          .medium
                                          .make(),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          employee.role!.text
                                              .size(14)
                                              .normal
                                              .make(),
                                          6.heightBox,
                                          Text(
                                              "${DateFormat('dd MMM, yy').format(DateTime.parse(employee.dateOfEmployment!.toString().split("|").first))}"
                                              " - ${DateFormat('dd MMM, yy').format(DateTime.parse(employee.dateOfEmployment!.toString().split("|").last))}"),

                                          // employee.dateOfEmployment!.text
                                          //     .size(12)
                                          //     .normal
                                          //     .make(),
                                        ],
                                      ),
                                    ),
                                    const Divider(height: 0),
                                  ],
                                ),
                              );
                            },
                          ),
                  ],
                );
        },
      ),
      floatingActionButton: Theme(
        data: ThemeData(
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(8.0), // Set the shape to a circle
            ),
            backgroundColor: Colors.blue,
          ),
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EmployeeDetailScreen(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> deleteEmployee(int index, employeeList) async {
    final dbHelper = DatabaseHelper();

    int rowsAffected = await dbHelper.deleteEmployee(employeeList[index].id);

    if (rowsAffected > 0) {
      setState(() {
        employeeList.removeAt(index);
      });

      print('Employee deleted successfully.');
    } else {
      print('No employee found with the specified id.');
    }
  }

  void _navigateToUpdatePage(Employee employee) {
    Navigator.of(context).push(
      MaterialPageRoute(
        // builder: (context) => UpdateEmployeeScreen(employee: employee),
        builder: (context) =>
            EmployeeDetailScreen(employee: employee, isEdit: true),
      ),
    );
  }
}
