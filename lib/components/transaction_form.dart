import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;

  TransactionForm(this.onSubmit);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  _submitForm() {
    final title = _titleController.text;
    final value = double.tryParse(_valueController.text ?? 0.0);
    if (title.isEmpty || value <= 0 || _selectedDate == null) {
      return;
    }
    widget.onSubmit(title, value, _selectedDate);
  }

  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      //when the datepicker is closed, THEN it will run this function...
      if (pickedDate == null) {
        return;
      } else {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    });
    //Code will run with the datepicker is opened
    //print("Still running...")
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: 10 +
                MediaQuery.of(context)
                    .viewInsets
                    .bottom, //Accounting for the device keyboard
          ),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                onSubmitted: (_) => _submitForm(),
                decoration: InputDecoration(
                  labelText: "Nome",
                ),
              ),
              TextField(
                controller: _valueController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                //iOS devices need to have decimal: true in order to display decimal options
                onSubmitted: (_) => _submitForm(),
                decoration: InputDecoration(
                  labelText: "Valor R\$ ",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    _selectedDate == null
                        ? Expanded(
                            child: Text(
                              "Nenhuma data selecionada.",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : Expanded(
                            child: Text(
                              "Data selecionada: ${DateFormat("d/MM/y").format(_selectedDate)}",
                            ),
                          ),
                    IconButton(
                      icon: Icon(
                        Icons.calendar_today,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: _showDatePicker,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: RaisedButton(
                      child: Text("Adicionar Transação"),
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).textTheme.button.color,
                      onPressed: _submitForm,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
