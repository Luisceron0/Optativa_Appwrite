import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:users/controllers/expense_controller.dart';
import 'package:users/model/expense_model.dart';

class ExpensesPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _emailController = TextEditingController();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();

  ExpensesPage({super.key});

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  void _submitExpense(ExpenseController controller) {
    if (_formKey.currentState!.validate()) {
      try {
        final date = DateFormat('dd/MM/yyyy').parse(_dateController.text);

        final expense = ExpenseModel.create(
          user: _userController.text,
          email: _emailController.text,
          title: _titleController.text,
          amount: double.parse(_amountController.text),
          date: date,
        );

        controller.addExpense(expense);

        // Clear form
        _userController.clear();
        _emailController.clear();
        _titleController.clear();
        _amountController.clear();
        _dateController.clear();
      } catch (e) {
        Get.snackbar(
          'Error',
          'Fecha inválida. Use el formato dd/MM/yyyy',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gastos con Appwrite')),
      body: GetX<ExpenseController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _userController,
                        decoration: InputDecoration(labelText: 'Usuario'),
                        validator:
                            (value) =>
                                value!.isEmpty ? 'Campo requerido' : null,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                        validator:
                            (value) =>
                                value!.isEmpty ? 'Campo requerido' : null,
                      ),
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(labelText: 'Título del gasto'),
                        validator:
                            (value) =>
                                value!.isEmpty ? 'Campo requerido' : null,
                      ),
                      TextFormField(
                        controller: _amountController,
                        decoration: InputDecoration(labelText: 'Monto'),
                        keyboardType: TextInputType.number,
                        validator:
                            (value) =>
                                value!.isEmpty ? 'Campo requerido' : null,
                      ),
                      TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          labelText: 'Fecha (dd/MM/yyyy)',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context),
                          ),
                        ),
                        readOnly: true,
                        validator:
                            (value) =>
                                value!.isEmpty ? 'Campo requerido' : null,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => _submitExpense(controller),
                        child: Text('Agregar Gasto'),
                      ),
                    ],
                  ),
                ),
              ),
              if (controller.error.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Error: ${controller.error.value}',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.expenses.length,
                  itemBuilder: (context, index) {
                    final expense = controller.expenses[index];
                    return ListTile(
                      title: Text(expense.title),
                      subtitle: Text(
                        'Usuario: ${expense.user}\n'
                        'Email: ${expense.email}\n'
                        'Monto: ${expense.amount.toStringAsFixed(2)} - ${_formatDate(expense.date)}',
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
