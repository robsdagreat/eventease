import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

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

  AuthUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  User? get user => _user;

  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });

    // Listen to Firebase auth state changes
    _auth.authStateChanges().listen((User? user) async {
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
            }
          }
        } catch (e) {
          developer.log('Error accessing Firestore', error: e);
        }
      } catch (e) {
        developer.log('Error in auth state changes', error: e);
        _currentUser = null;
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

  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> updateProfile({
    required String name,
    required bool notificationsEnabled,
    required ThemeMode themeMode,
  }) async {
    if (_currentUser == null) return;

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
        // Continue even if Firestore fails
      }

      _currentUser = AuthUser(
        id: _currentUser!.id,
        email: _currentUser!.email,
        name: name,
        notificationsEnabled: notificationsEnabled,
        themeMode: themeMode,
      );

      notifyListeners();
    } catch (e) {
      developer.log('Update profile error', error: e);
      rethrow;
    }
  }

  Future<void> deleteAccount(String password) async {
    if (_currentUser == null || _auth.currentUser == null) {
      throw Exception('No authenticated user found');
    }

    try {
      _isLoading = true;
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
        // Continue even if Firestore fails
      }

      // Delete user from Firebase
      await _auth.currentUser!.delete();

      _currentUser = null;
      notifyListeners();
    } catch (e) {
      developer.log('Delete account error', error: e);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
