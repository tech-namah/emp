// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:developer';

import 'package:emp_management_ansh_ramani/Component/calendar_widget.dart';
import 'package:emp_management_ansh_ramani/Controller/employee.dart';
import 'package:emp_management_ansh_ramani/database.dart';
import 'package:emp_management_ansh_ramani/model/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

enum DateOption {
  today,
  nextMonday,
  nextTuesday,
  afterOneWeek,
}

class EmployeeDetailScreen extends StatefulWidget {
  Employee? employee;
  bool isEdit;
  EmployeeDetailScreen({super.key,this.employee,this.isEdit = false});

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  final TextEditingController nameController = TextEditingController();
  String? selectedRole;
  DateTime? selectedDate;
  DateTime? lastDate ;
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    if(widget.isEdit == true){
      nameController.text = widget.employee!.name!;
      selectedRole = widget.employee!.role!;
      selectedDate = DateTime.parse(widget.employee!.dateOfEmployment!.toString().split('|').first);
      if(widget.employee!.dateOfEmployment!.toString().split('|').last.isNotEmpty) {
        lastDate = DateTime.parse(widget.employee!.dateOfEmployment!.toString().split('|').last);
      }
    }
    else{
      selectedDate = DateTime.now();
      // lastDate = DateTime.now();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Employee Detail'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          16.heightBox,
          TextFormField(
            controller: nameController,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'Employee name',
              prefixIcon: const Icon(Icons.person_outline, color: Colors.blue),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          ).px12(),
          20.heightBox,
          GestureDetector(
            onTap: () {
              showRoleSelection(context);
            },
            child: InputDecorator(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.work_outline, color: Colors.blue),
                suffixIcon: const Icon(
                  Icons.arrow_drop_down_rounded,
                  color: Colors.blue,
                  size: 35,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              child: Text(selectedRole ?? 'Select role'),
            ),
          ).px12(),
          20.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.event_outlined,
                      color: Colors.blue,
                    ),
                    TextButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _showCustomDatePickerDialog(context,callBack: (v) {
                          selectedDate =v;
                          setState(() {
                          });
                        });
                      },
                      child:  Row(
                        children: [
                          Text(
                            DateFormat('dd MMM y').format(selectedDate!),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).px12(),
              ),
              SvgPicture.asset('assets/vector.svg')/*.p12()*/,
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.event_outlined,
                      color: Colors.blue,
                    ),
                    TextButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _showCustomDatePickerDialog(context, isLastDate:true,
                            callBack: (v) {
                          if(selectedDate == v ||
                              DateTime.parse(v.toString()).millisecondsSinceEpoch < DateTime.parse(selectedDate.toString()).millisecondsSinceEpoch
                          ){
                            // print("same as from date  selectedDate  ${selectedDate == v}");
                            // print("same as from date  v $v");
                          }else{
                            lastDate = v;
                          }

                          setState(() {});
                        });
                      },
                      child:  Text(
                          lastDate == null ?"No Date":  DateFormat('dd MMM y').format(lastDate!),
                      ),
                    ),
                  ],
                ).px12(),
              ),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Divider(
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xffEDF8FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: 'Cancel'.text.medium.size(14).sky500.make(),
                    ),
                    15.widthBox,
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      onPressed: widget.isEdit == false ? saveEmployee : updateEmployee,
                      child: 'Save'.text.medium.size(14).make(),
                    ),
                  ],
                ).px12()
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showRoleSelection(BuildContext context) {
    final List<String> roles = [
      'Product Designer',
      'Flutter Developer',
      'QA Tester',
      'Product Owner',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 250,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: roles.length,
            itemBuilder: (context, index) {
              final role = roles[index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  5.heightBox,
                  role.text.size(16).makeCentered().onTap(() {
                    setState(() {
                      selectedRole = role;
                    });
                    Navigator.pop(context);
                  }).p12(),
                  const Divider(),
                ],
              );
            },
          ),
        );
      },
    );
  }

  _showCustomDatePickerDialog(BuildContext context,{Function(DateTime)? callBack,bool isLastDate=false}) {
    // DateOption selectedDateOption = DateOption.today;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // var formattedDate = DateFormat('d MMMM y').format(selectedDate);
        return AlertDialog(
          insetPadding: const EdgeInsets.only(left: 20, right: 20),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10.0), // Adjust the radius as needed
          ),
          content: SizedBox(
            // height: 475,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Calendar(

         selectedDate: selectedDate,
              callBack: callBack,isLastDate:isLastDate),

          ),
          /*actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xffEDF8FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: 'Cancel'.text.medium.size(14).sky500.make(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
              onPressed: () {
                saveEmployee();
                Navigator.of(context).pop();
              },
              child: 'Save'.text.medium.size(14).make(),
            ),
          ],*/
        );
      },
    );
  }

  Widget _buildDateOptionButton({
    required String text,
    required DateOption dateOption,
    required DateOption selectedDateOption,
    required void Function() onTap,
  }) {
    final isSelected = dateOption == selectedDateOption;
    return Container(
      decoration: isSelected
          ? BoxDecoration(
              border: Border.all(width: 4, color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : null,
        ),
        child: Text(text),
      ),
    );
  }

  void saveEmployee() {
    try {

      if (mounted) {
        if(nameController.text.isEmpty){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Enter Name!'),
          ));
        }
        else if(selectedRole == null || selectedRole!.isEmpty){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Enter Role!'),
          ));
        }
        else if(selectedDate == null || selectedDate.toString().isEmpty){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Enter From Date!'),
          ));

        }
        else{
          String endDate = lastDate == null || lastDate.toString().isEmpty
              ? ""
              : lastDate.toString();
          final employee = Employee(
            name: nameController.text,
            role: selectedRole ?? '',
            // dateOfEmployment: "${selectedDate.toString()}|${lastDate.toString()}",
            dateOfEmployment: "${selectedDate.toString()}|${endDate}",
          );

          final dbHelper = DatabaseHelper();
          dbHelper.insertEmployee(employee).then((_) {
            final employeeBloc = context.read<EmployeeBloc>();
            employeeBloc.getEmployees();
            Navigator.of(context).pop();
            // Show a snackBar message
          });
        }
      }
    } on Exception catch (e) {
      log("e ====> $e");
    }
  }

  Future<void> updateEmployee() async {
    if(nameController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Enter Name!'),
      ));
    }
    else if(selectedRole == null || selectedRole!.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Enter Role!'),
      ));
    }
    else if(selectedDate == null || selectedDate.toString().isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Enter From Date!'),
      ));
    }
    else{
      String endDate = lastDate == null || lastDate.toString().isEmpty
          ? ""
          : lastDate.toString();
      Employee updatedEmployee = Employee(
        id: widget.employee!.id!,
        name: nameController.text,
        role: selectedRole ?? '',
        // dateOfEmployment: "${selectedDate.toString()}|${lastDate.toString()}",
        dateOfEmployment: "${selectedDate.toString()}|${endDate}",
      );
      final employeeBloc = context.read<EmployeeBloc>();

      final dbHelper = DatabaseHelper();
      int rowsAffected = await dbHelper.updateEmployee(updatedEmployee);

      if (rowsAffected > 0) {
        employeeBloc.getEmployees();
        Navigator.of(context).pop();
      } else {
        employeeBloc.getEmployees();
        Navigator.of(context).pop();
      }
    }
  }

}
