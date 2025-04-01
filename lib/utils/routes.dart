import 'package:flutter/cupertino.dart';
import 'package:pobre_simulator/view/categories_list_page.dart';
import 'package:pobre_simulator/view/home_page.dart';
import 'package:pobre_simulator/view/transaction_page.dart';

class Routes {
  static const String initialRoute = '/home';
  static const String transactionsRoute = '/transactions';
  static const String categoriesRoute = '/categories';

  static final Map<String, WidgetBuilder> routes = {
    initialRoute: (context) => HomePage(),
    categoriesRoute: (context) => CategoriesListPage(),
    transactionsRoute: (context) => const TransactionPage(),
  };
}

void customPush(BuildContext context, Widget pPage) async {
  Navigator.of(context).push(
    CupertinoPageRoute(
      builder: (context) => pPage,
    ),
  );
}

Future<T?> customPushNamed<T extends Object?>(BuildContext context, String pRoute) async {
  return Navigator.of(context).pushNamed(pRoute);
}
