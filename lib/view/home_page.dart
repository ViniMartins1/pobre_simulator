import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pobre_simulator/controller/home_controller.dart';
import 'package:pobre_simulator/view/home_header.dart';
import 'package:pobre_simulator/view/transactions_list.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      context.read<HomeController>().init();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(builder: (context, value, child) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              HomeHeader(),
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transactions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.calendar_today, size: 20),
                          onPressed: () {
                            // Date filter action
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.filter_list),
                          onPressed: () {
                            // Category filter action
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Transactions list
              Expanded(
                child: TransactionsList(transactions: value.transactions),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Stats'),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
          ],
          currentIndex: 0,
          onTap: (index) {
            // Handle navigation
          },
        ),
      );
    });
  }
}


/* 
  final List<Transaction> demoTransactions = [
    Transaction(
      id: 1,
      title: 'Grocery Shopping',
      category: 'Food & Groceries',
      amount: 85.32,
      date: DateTime.now().subtract(Duration(hours: 3)),
      isExpense: true,
      categoryIcon: Icons.shopping_basket,
      categoryColor: Colors.orange,
    ),
    Transaction(
      id: '2',
      title: 'Monthly Salary',
      category: 'Income',
      amount: 3250.00,
      date: DateTime.now().subtract(Duration(days: 1)),
      isExpense: false,
      categoryIcon: Icons.wallet,
      categoryColor: Colors.green,
    ),
    Transaction(
      id: '3',
      title: 'Electric Bill',
      category: 'Utilities',
      amount: 72.45,
      date: DateTime.now().subtract(Duration(days: 2)),
      isExpense: true,
      categoryIcon: Icons.electric_bolt,
      categoryColor: Colors.blue,
    ),
    Transaction(
      id: '4',
      title: 'Netflix Subscription',
      category: 'Entertainment',
      amount: 12.99,
      date: DateTime.now().subtract(Duration(days: 2)),
      isExpense: true,
      categoryIcon: Icons.movie,
      categoryColor: Colors.red,
    ),
  ];
*/