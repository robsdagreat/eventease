import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
      print('Error in AuthUser.fromMap: $e');
      rethrow;
    }
  }
}

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthUser? _currentUser;
  bool _isLoading = false;

  AuthUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  AuthService() {
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
              print('Error creating user in Firestore: $e');
            }
          }
        } catch (e) {
          print('Error accessing Firestore: $e');
        }
      } catch (e) {
        print('Error in auth state changes: $e');
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Configure reCAPTCHA settings
      await _auth.setSettings(
        appVerificationDisabledForTesting: true,
        phoneNumber: null,
        smsCode: null,
      );

      // Sign in with Firebase
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('No user returned from Firebase');
      }

      final user = userCredential.user!;

      // Create basic user object
      final basicUser = AuthUser(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? user.email?.split('@')[0] ?? '',
      );

      // Set the basic user immediately
      _currentUser = basicUser;
      notifyListeners();

      // Show success toast
      Fluttertoast.showToast(
        msg: "Successfully logged in!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

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
            print('Error creating user in Firestore: $e');
          }
        }
      } catch (e) {
        print('Error accessing Firestore: $e');
        // Continue with basic user data if Firestore fails
      }
    } catch (e) {
      print('Sign in error: $e');
      _currentUser = null;
      notifyListeners();

      // Show error toast
      Fluttertoast.showToast(
        msg:
            "Login failed: ${e is FirebaseAuthException ? e.message : 'Unknown error'}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Configure reCAPTCHA settings
      await _auth.setSettings(
        appVerificationDisabledForTesting: true,
        phoneNumber: null,
        smsCode: null,
      );

      // Create user in Firebase
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('No user returned from Firebase');
      }

      final user = userCredential.user!;

      // Create user in Firestore
      final newUser = AuthUser(
        id: user.uid,
        email: email,
        name: name,
      );

      try {
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
      } catch (e) {
        print('Error creating user in Firestore: $e');
        // Continue even if Firestore fails
      }

      _currentUser = newUser;
      notifyListeners();
    } catch (e) {
      print('Sign up error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      print('Sign out error: $e');
      rethrow;
    }
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
        print('Error updating Firestore: $e');
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
      print('Update profile error: $e');
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
        print('Error deleting user from Firestore: $e');
        // Continue even if Firestore fails
      }

      // Delete user from Firebase
      await _auth.currentUser!.delete();

      _currentUser = null;
      notifyListeners();
    } catch (e) {
      print('Delete account error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
