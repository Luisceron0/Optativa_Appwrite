import 'package:appwrite/appwrite.dart';
import 'package:users/core/constants/appwrite_constants.dart';
import 'package:users/model/expense_model.dart';

class ExpenseRepository {
  final Databases databases;

  ExpenseRepository(this.databases);

  Future<ExpenseModel> createExpense(ExpenseModel expense) async {
    try {
      final response = await databases.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionId,
        documentId: ID.unique(),
        data: expense.toJson(),
      );

      return ExpenseModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ExpenseModel>> getExpenses({String? user}) async {
    try {
      final List<String> queries = [];

      if (user != null && user.isNotEmpty) {
        queries.add(Query.equal('user', user));
      }

      final response = await databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionId,
        queries: queries.isNotEmpty ? queries : null,
      );

      return response.documents
          .map((doc) => ExpenseModel.fromJson(doc.data))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ExpenseModel>> getAllExpenses() async {
    try {
      final response = await databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionId,
      );

      return response.documents
          .map((doc) => ExpenseModel.fromJson(doc.data))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
