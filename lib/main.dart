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
        textTheme: ThemeData.light().textTheme.copyWith(
              button: TextStyle(
                color: Colors.white,
              ),
            ),
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
  bool _showChart = false;
  final List<Transaction> _transactions = [
    //Hard coding transactions for testing purposes
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
    )
  ];

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop(); //Closing modal
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  Future<void> _showDeletionDialog(String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (_) {
        return AlertDialog(
          title: Text("Remover Transação"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text("Essa ação não pode ser desfeita."),
                Text("Tem certeza que deseja continuar?"),
              ],
            ),
          ),
          actions: [
            FlatButton(
              child: Text("Não"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Sim"),
              onPressed: () {
                _removeTransaction(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
    final mediaQuery = MediaQuery.of(context);
    //Detect if the device is in landscape mode
    bool _isLandscape = mediaQuery.orientation == Orientation.landscape;
    if (!_isLandscape)
      _showChart = false; //Reset the view when turning the device

    final appBar = AppBar(
      title: Text("Despesas Pessoais"),
      actions: [
        _isLandscape
            ? Row(
                children: [
                  IconButton(
                    icon: Icon(
                        _showChart ? Icons.attach_money : Icons.insert_chart),
                    onPressed: () {
                      setState(() {
                        _showChart = !_showChart;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => _openTransactionFormModal(context),
                  ),
                ],
              )
            : IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _openTransactionFormModal(context),
              ),
      ],
    );
    final availableHeight = mediaQuery.size.height - //Total device height
        appBar.preferredSize.height - //Appbar size
        mediaQuery.padding.top - //Notification bar top (or notch)
        mediaQuery.padding.bottom; //Unused screen bottom (s8 rounded corners)
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_showChart || !_isLandscape)
              Container(
                height: availableHeight * (_isLandscape ? 0.95 : 0.20),
                child: Chart(_recentTransactions),
              ),
            if (!_showChart || !_isLandscape)
              Column(
                children: [
                  Container(
                    height: availableHeight * (_isLandscape ? 1 : 0.8),
                    child: TransactionList(_transactions, _showDeletionDialog),
                  ),
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
