import 'package:emp_management_ansh_ramani/Controller/employee.dart';
import 'package:emp_management_ansh_ramani/Screen/employee_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        BlocProvider<EmployeeBloc>(
          create: (context) => EmployeeBloc(),
        ),
        // Other providers if any
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final employeeBloc = context.read<EmployeeBloc>();
    // Call the getEmployees method to fetch data when the app starts
    employeeBloc.getEmployees();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.blue,
      ),
      home: const EmployeeListScreen(),
    );
  }
}
