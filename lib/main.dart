import 'package:flutter/material.dart';
import 'package:pobre_simulator/config/db.dart';
import 'package:pobre_simulator/config/themes.dart';
import 'package:pobre_simulator/controller/category_controller.dart';
import 'package:pobre_simulator/controller/home_controller.dart';
import 'package:pobre_simulator/controller/transaction_controller.dart';
import 'package:pobre_simulator/utils/routes.dart';
import 'package:pobre_simulator/view/home_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CustomTheme.applyStatusBarColor();

  DB db = DB();
  await db.initDb();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeController()),
        ChangeNotifierProvider(create: (context) => CategoryController()),
        ChangeNotifierProvider(create: (context) => TransactionController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pobre simulator',
      home: const HomePage(),
      theme: CustomTheme.lightTheme,
      initialRoute: Routes.initialRoute,
      routes: Routes.routes,
    );
  }
}
