import '../models/models.dart';

abstract class AuthService {
  Future<Student> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Student> createUserWithEmailAndPassword({
    required String firstName,
    required String middleName,
    required String lastName,
    required String email,
    required String password,
  });
}
