import 'package:flutter/material.dart';
import 'package:personal_expenses/components/adaptive/adaptive_button.dart';
import 'package:personal_expenses/components/adaptive/adaptive_datepicker.dart';
import 'package:personal_expenses/components/adaptive/adaptive_textfield.dart';

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
              AdaptiveTextField(
                controller: _titleController,
                onSubmitted: (_) => _submitForm(),
                label: "Nome",
              ),
              AdaptiveTextField(
                controller: _valueController,
                onSubmitted: (_) => _submitForm(),
                label: "Valor R\$",
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              AdaptiveDatepicker(
                selectedDate: _selectedDate,
                initialDate: DateTime.now(),
                firstDate: DateTime(DateTime.now().year - 2),
                lastDate: DateTime.now(),
                onDateChanged: (newDate) {
                  setState(() {
                    _selectedDate = newDate;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: AdaptiveButton(
                      label: "Adicionar Transação",
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
