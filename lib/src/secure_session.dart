import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionManager {
  final storage = const FlutterSecureStorage();

  SessionManager._();

  static final SessionManager _instance = SessionManager._();

  // Step 3: Static factory method
  factory SessionManager() {
    return _instance;
  }

  Future<void> startSession(String email, String phone, String password,
      String token, int role, String? teamId, String name) async {
    await storage.write(key: "name", value: name);
    await storage.write(key: "email", value: email);
    await storage.write(key: "phone", value: phone);
    await storage.write(key: "password", value: password);
    await storage.write(key: "token", value: token);
    await storage.write(key: "teamId", value: teamId);
    await storage.write(key: "role", value: role.toString());
    await storage.write(key: "isLoggedIn", value: "true");
  }

  Future<Map<String, dynamic>> getSession() async {
    String? email = await storage.read(key: "email");
    String? phone = await storage.read(key: "phone");
    String? password = await storage.read(key: 'password');
    String? token = await storage.read(key: 'token');
    int? role = int.tryParse(await storage.read(key: 'role') ?? '1');
    String? name = await storage.read(key: 'name');
    return {
      'email': email ?? '',
      'phone': phone ?? '',
      'password': password ?? '',
      'token': token ?? '',
      'role': role ?? 1,
      'name': name ?? ''
    };
  }

  Future<bool> isLoggedIn() async {
    String? isLogged = await storage.read(key: "isLoggedIn");
    return isLogged == 'true';
  }

  Future<void> endSession() async {
    await storage.delete(key: "email");
    await storage.delete(key: "phone");
    await storage.delete(key: "password");
    await storage.delete(key: "token");
    await storage.write(key: "isLoggedIn", value: "loggedOut");
  }
}
