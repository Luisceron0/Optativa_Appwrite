import 'package:get/get.dart';
import 'package:users/model/expense_model.dart';
import 'package:users/data/repositories/expense_repository.dart';

class ExpenseController extends GetxController {
  final ExpenseRepository repository;

  ExpenseController({required this.repository});

  // Estado reactivo
  final RxList<ExpenseModel> expenses = <ExpenseModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllExpenses();
  }

  Future<void> fetchAllExpenses() async {
    try {
      isLoading.value = true;
      final fetchedExpenses = await repository.getAllExpenses();
      expenses.assignAll(fetchedExpenses);
    } catch (e) {
      error.value = e.toString();
      expenses.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchExpensesByUser(String user) async {
    try {
      isLoading.value = true;
      final fetchedExpenses = await repository.getExpenses(user: user);
      expenses.assignAll(fetchedExpenses);
    } catch (e) {
      error.value = e.toString();
      expenses.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addExpense(ExpenseModel expense) async {
    try {
      final newExpense = await repository.createExpense(expense);
      expenses.add(newExpense);
    } catch (e) {
      error.value = e.toString();
    }
  }
}
