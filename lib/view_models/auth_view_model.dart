import 'package:flutter/material.dart';
import 'package:travel_pack/data/models/user_model.dart';
import 'package:travel_pack/data/repositories/auth_repository.dart';
import '../utils/app_exceptions/app_exceptions.dart';

class AuthViewModel with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserModel? _user;
  UserModel? get user => _user;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
    required String photoUrl,
    required String createdAt,
    required String confirmPassword,
  }) async {
    _clearError();

    // ✅ Start loading
    _setLoading(true);

    try {
      // ✅ Field validation
      if (displayName.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          confirmPassword.isEmpty) {
        _setErrorMessage('Please fill all the fields');
        return;
      }

      if (password.length < 6) {
        _setErrorMessage('Password must be at least 6 characters');
        return;
      }

      if (password != confirmPassword) {
        _setErrorMessage('Passwords do not match');
        return;
      }

      final result = await _authRepository.signUp(
        email,
        password,
        displayName,
        photoUrl,
        createdAt,
      );

      _user = result;
    } on AppException catch (e) {
      _setErrorMessage(e.message);
    } catch (e) {
      _setErrorMessage('An unexpected error occurred: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logIn(String email, String password) async {
    _clearError();
    _setLoading(true);

    try {
      if (email.isEmpty || password.isEmpty) {
        _setErrorMessage('Please fill all fields');
        _setLoading(false); // Add this
        return;
      }

      final result = await _authRepository.signIn(email, password);
      _user = result;
    } on AppException catch (e) {
      _setErrorMessage(e.message);
    } catch (e) {
      _setErrorMessage('Login failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  //User signOut
  Future<void> signOut() async {
    await _authRepository.signOut();
  }
}
