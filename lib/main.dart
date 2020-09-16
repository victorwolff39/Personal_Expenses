import 'dart:math';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:personal_expenses/components/transaction_form.dart';
import 'package:personal_expenses/components/chart.dart';
import 'package:flutter/material.dart';
import 'components/transaction_form.dart';
import 'components/transaction_list.dart';
import 'models/transaction.dart';

main() => runApp(PersonalExpensesApp());

class PersonalExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
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

class _MyHomePageState
    extends State<MyHomePage> /*with WidgetsBindingObserver*/ {
  /*
  //--Example of a OBSERVER to check for updates in app state (app closed, app not in focus...)

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); //Adding a observer
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state); //Action executed when app state is updated
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this); //Removing observer when not in use
  }

  //P.s. uncomment "with WidgetsBindingObserver" from class _MyHomePageState to use the observer
  */

  bool isIOS = Platform.isIOS;

  //bool isIOS = true; //Fixed platform, because I don't have a iOS device... -_-
  bool _showChart = false;
  final List<Transaction> _transactions = [];

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

  Widget _getIconButton(IconData icon, Function fn) {
    return isIOS
        ? GestureDetector(
            onTap: fn,
            child: Icon(icon),
          )
        : IconButton(icon: Icon(icon), onPressed: fn);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    //Detect if the device is in landscape mode
    bool _isLandscape = mediaQuery.orientation == Orientation.landscape;
    if (!_isLandscape)
      _showChart = false; //Reset the view when turning the device

    //Icons:
    final iconList = isIOS ? CupertinoIcons.refresh : Icons.refresh;
    final iconChart = isIOS ? CupertinoIcons.refresh : Icons.insert_chart;
    final iconAdd = isIOS ? CupertinoIcons.add : Icons.add;
    //End-Icons

    final actions = [
      _isLandscape
          ? Row(
              children: [
                _getIconButton(
                  _showChart ? iconList : iconChart,
                  () {
                    setState(() {
                      _showChart = !_showChart;
                    });
                  },
                ),
                _getIconButton(
                    iconAdd, () => _openTransactionFormModal(context)),
              ],
            )
          : _getIconButton(
              iconAdd,
              () => _openTransactionFormModal(context),
            ),
    ];
    final PreferredSizeWidget appBar = isIOS
        ? CupertinoNavigationBar(
            middle: Text("Despesas Pessoais"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ),
          )
        : AppBar(title: Text("Despesas Pessoais"), actions: actions);
    final availableHeight = mediaQuery.size.height - //Total device height
        appBar.preferredSize.height - //Appbar size
        mediaQuery.padding.top - //Notification bar top (or notch)
        mediaQuery.padding.bottom; //Unused screen bottom (s8 rounded corners)
    final bodyPage = SafeArea(
      child: SingleChildScrollView(
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
    );

    return isIOS
        ? CupertinoPageScaffold(
            child: bodyPage,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _openTransactionFormModal(context),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
