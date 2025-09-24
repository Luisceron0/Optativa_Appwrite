import 'package:appwrite/appwrite.dart';
import 'package:users/core/constants/appwrite_constants.dart';

class AppwriteConfig {
  static const String endpoint = AppwriteConstants.endpoint;
  static const String projectId = AppwriteConstants.projectId;

  static Client initClient() {
    final client = Client().setEndpoint(endpoint).setProject(projectId);
    return client;
  }

  static Databases initDatabase(Client client) {
    return Databases(client);
  }
}
