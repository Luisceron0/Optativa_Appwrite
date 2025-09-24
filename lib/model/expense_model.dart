class ExpenseModel {
  final String id;
  final String user;
  final String email;
  final String title;
  final double amount;
  final DateTime date;

  ExpenseModel({
    required this.id,
    required this.user,
    required this.email,
    required this.title,
    required this.amount,
    required this.date,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['\$id'],
      user: json['user'],
      email: json['email'],
      title: json['title'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() => {
        'user': user,
        'email': email,
        'title': title,
        'amount': amount,
        'date': date.toIso8601String(),
      };

  // Constructor for creating new expenses from form
  factory ExpenseModel.create({
    required String user,
    required String email,
    required String title,
    required double amount,
    required DateTime date,
  }) {
    return ExpenseModel(
      id: '',
      user: user,
      email: email,
      title: title,
      amount: amount,
      date: date,
    );
  }
}
