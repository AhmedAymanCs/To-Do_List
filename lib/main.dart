import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_list/screens/home.dart';
import 'package:todo_list/services/task_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStorage.init();
  final bool isDark = await AppStorage.getTheme();
  runApp(MyApp(isDark: isDark));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.isDark});
  final bool isDark;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode themeMode;

  @override
  void initState() {
    super.initState();
    themeMode = widget.isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() {
    setState(() {
      themeMode = themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });

    AppStorage.setTheme(themeMode == ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      ensureScreenSize: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Todo List',
          themeMode: themeMode,
          darkTheme: ThemeData.dark(),
          theme: ThemeData.light(),
          home: HomeScreen(onToggleTheme: toggleTheme),
        );
      },
    );
  }
}
