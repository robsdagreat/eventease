import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

class AuthUser {
  final String id;
  final String email;
  final String name;
  final bool notificationsEnabled;
  final ThemeMode themeMode;

  AuthUser({
    required this.id,
    required this.email,
    required this.name,
    this.notificationsEnabled = true,
    this.themeMode = ThemeMode.system,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'notifications_enabled': notificationsEnabled,
      'theme_mode': themeMode.toString(),
    };
  }

  factory AuthUser.fromMap(Map<String, dynamic> map) {
    try {
      return AuthUser(
        id: map['id']?.toString() ?? '',
        email: map['email']?.toString() ?? '',
        name: map['name']?.toString() ?? '',
        notificationsEnabled: map['notifications_enabled'] ?? true,
        themeMode: ThemeMode.values.firstWhere(
          (e) =>
              e.toString() ==
              (map['theme_mode']?.toString() ?? 'ThemeMode.system'),
          orElse: () => ThemeMode.system,
        ),
      );
    } catch (e) {
      developer.log('Error in AuthUser.fromMap', error: e);
      rethrow;
    }
  }
}

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthUser? _currentUser;
  bool _isLoading = false;
  User? _user;
  String? _errorMessage;

  AuthUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  User? get user => _user;
  String? get errorMessage => _errorMessage;

  AuthService() {
    // Single listener for auth state changes
    _auth.authStateChanges().listen((User? user) async {
      _user = user;
      if (user == null) {
        _currentUser = null;
        notifyListeners();
        return;
      }

      try {
        // Create a basic user object from Firebase Auth data
        final basicUser = AuthUser(
          id: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? user.email?.split('@')[0] ?? '',
        );

        // Set the basic user immediately
        _currentUser = basicUser;
        notifyListeners();

        // Try to get additional data from Firestore
        try {
          final userDoc =
              await _firestore.collection('users').doc(user.uid).get();

          if (userDoc.exists) {
            final userData = userDoc.data()!;
            _currentUser = AuthUser.fromMap({
              'id': user.uid,
              ...userData,
            });
            notifyListeners();
          } else {
            // Create new user in Firestore
            try {
              await _firestore
                  .collection('users')
                  .doc(user.uid)
                  .set(basicUser.toMap());
            } catch (e) {
              developer.log('Error creating user in Firestore', error: e);
              _errorMessage =
                  'Failed to create user profile. Please try again.';
              notifyListeners();
            }
          }
        } catch (e) {
          developer.log('Error accessing Firestore', error: e);
          _errorMessage =
              'Could not access user profile. Please check your connection or permissions.';
          notifyListeners();
        }
      } catch (e) {
        developer.log('Error in auth state changes', error: e);
        _currentUser = null;
        _errorMessage = 'Authentication error. Please try again.';
        notifyListeners();
      }
    });
  }

  Future<bool> isLoggedIn() async {
    return _auth.currentUser != null;
  }

  Future<String?> getToken() async {
    return await _auth.currentUser?.getIdToken();
  }

  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Login failed. Please try again.';
      notifyListeners();
      return null;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred during login.';
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<UserCredential?> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user name to Firestore
      if (result.user != null) {
        await _firestore.collection('users').doc(result.user!.uid).set({
          'name': name,
          'email': email,
          // Add other initial user data if needed
        });

        // Manually update the current user with the name
        _currentUser = AuthUser(
          id: result.user!.uid,
          email: result.user!.email ?? '',
          name: name,
          // Copy other default values from AuthUser constructor if necessary
        );
        notifyListeners();
      }

      return result;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Signup failed. Please try again.';
      notifyListeners();
      return null;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred during signup.';
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _currentUser = null;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Sign out failed. Please try again.';
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    required String name,
    required bool notificationsEnabled,
    required ThemeMode themeMode,
  }) async {
    if (_currentUser == null) {
      _errorMessage = 'No user is currently logged in.';
      notifyListeners();
      return;
    }

    try {
      // Update Firestore if available
      try {
        await _firestore.collection('users').doc(_currentUser!.id).update({
          'name': name,
          'notifications_enabled': notificationsEnabled,
          'theme_mode': themeMode.toString(),
        });
      } catch (e) {
        developer.log('Error updating Firestore', error: e);
        _errorMessage = 'Failed to update profile. Please try again.';
        notifyListeners();
        // Continue even if Firestore fails
      }

      _currentUser = AuthUser(
        id: _currentUser!.id,
        email: _currentUser!.email,
        name: name,
        notificationsEnabled: notificationsEnabled,
        themeMode: themeMode,
      );

      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      developer.log('Update profile error', error: e);
      _errorMessage = 'An error occurred while updating your profile.';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteAccount(String password) async {
    if (_currentUser == null || _auth.currentUser == null) {
      _errorMessage = 'No authenticated user found.';
      notifyListeners();
      throw Exception('No authenticated user found');
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Re-authenticate user before deleting account
      final credential = EmailAuthProvider.credential(
        email: _currentUser!.email,
        password: password,
      );
      await _auth.currentUser!.reauthenticateWithCredential(credential);

      // Delete user data from Firestore if available
      try {
        await _firestore.collection('users').doc(_currentUser!.id).delete();
      } catch (e) {
        developer.log('Error deleting user from Firestore', error: e);
        _errorMessage = 'Failed to delete user data from server.';
        notifyListeners();
        // Continue even if Firestore fails
      }

      // Delete user from Firebase
      await _auth.currentUser!.delete();

      _currentUser = null;
      _errorMessage = null;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Account deletion failed. Please try again.';
      notifyListeners();
      rethrow;
    } catch (e) {
      developer.log('Delete account error', error: e);
      _errorMessage = 'An error occurred while deleting your account.';
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
