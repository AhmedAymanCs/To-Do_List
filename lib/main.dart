import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_list/screens/home.dart';
import 'package:todo_list/screens/logic/cubit.dart';
import 'package:todo_list/screens/logic/states.dart';
import 'package:todo_list/services/task_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      ensureScreenSize: true,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => AppCubit()
            ..getTasks()
            ..initalTheme(),
          child: BlocConsumer<AppCubit, AppState>(
            listener: (context, state) {},
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Todo List',
                themeMode: AppCubit.get(context).isDarkTheme
                    ? ThemeMode.dark
                    : ThemeMode.light,
                darkTheme: ThemeData.dark(),
                theme: ThemeData.light(),
                home: HomeScreen(),
              );
            },
          ),
        );
      },
    );
  }
}
