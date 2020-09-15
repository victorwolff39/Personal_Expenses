import 'package:personal_expenses/components/chart.dart';
import 'package:personal_expenses/components/transaction_form.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'components/transaction_form.dart';
import 'components/transaction_list.dart';
import 'models/transaction.dart';

main() => runApp(PersonalExpensesApp());

class PersonalExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: "Quicksand",
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
    Transaction(
      id: "t0",
      title: "New Computer",
      value: 4955.50,
      date: DateTime.now().subtract(Duration(days: 33)),
    ),
    Transaction(
      id: "t1",
      title: "Steam",
      value: 152.95,
      date: DateTime.now().subtract(Duration(days: 3)),
    ),
    Transaction(
      id: "t2",
      title: "FrontierStore",
      value: 17.25,
      date: DateTime.now().subtract(Duration(days: 2)),
    ),
    Transaction(
      id: "t3",
      title: "Empadas Jerke",
      value: 34.68,
      date: DateTime.now().subtract(Duration(days: 2)),
    ),
    Transaction(
      id: "t4",
      title: "Hamburgueria",
      value: 25.00,
      date: DateTime.now().subtract(Duration(days: 2)),
    ),
    Transaction(
      id: "t5",
      title: "Conta de Internet",
      value: 149.90,
      date: DateTime.now().subtract(Duration(days: 4)),
    ),
    Transaction(
      id: "t6",
      title: "Cartão de Crédito",
      value: 1589.55,
      date: DateTime.now().subtract(Duration(days: 0)),
    ),
    Transaction(
      id: "t7",
      title: "Roupas",
      value: 259.42,
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      id: "t8",
      title: "Conta de Energia",
      value: 32400.91,
      date: DateTime.now().subtract(Duration(days: 2)),
    ),
    Transaction(
      id: "t8",
      title: "Private Internet Access",
      value: 52.42,
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
  ];

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  _addTransaction(String title, double value) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: DateTime.now(),
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop(); //Closing modal
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Despesas Pessoais"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () => _openTransactionFormModal(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Chart(_recentTransactions)
            ),
            Column(
              children: [
                TransactionList(_transactions),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _openTransactionFormModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
