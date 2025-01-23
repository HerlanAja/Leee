import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  bool islogin = true;
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  User? currentUser;

  // Login Method
  Future<void> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      currentUser = userCredential.user;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    }
  }

  // Register Method
  Future<void> registerUser({
    required String email, 
    required String password,
    String? username
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );

      // Simpan data user di Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'username': username ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      currentUser = userCredential.user;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    }
  }

  // Submit Method
  Future<void> submit(String email, String password) async {
    if (!form.currentState!.validate()) return;

    try {
      if (islogin) {
        await loginUser(email, password);
      } else {
        await registerUser(email: email, password: password);
      }
    } catch (e) {
      print('Submit Error: $e');
    }
  }

  // Error Handling
  void _handleAuthError(FirebaseAuthException e) {
    String errorMessage = 'Terjadi kesalahan';
    
    switch (e.code) {
      case 'user-not-found':
        errorMessage = 'Pengguna tidak ditemukan';
        break;
      case 'wrong-password':
        errorMessage = 'Password salah';
        break;
      case 'email-already-in-use':
        errorMessage = 'Email sudah terdaftar';
        break;
      case 'weak-password':
        errorMessage = 'Password terlalu lemah';
        break;
    }
    
    // Tampilkan error via SnackBar
    ScaffoldMessenger.of(form.currentContext!).showSnackBar(
      SnackBar(content: Text(errorMessage))
    );
  }

  // Method untuk mengambil data pengguna
  Future<DocumentSnapshot> getUserData() async {
    if (currentUser != null) {
      return await _firestore.collection('users').doc(currentUser!.uid).get();
    }
    throw Exception('User not logged in');
  }

  // Logout Method
  Future<void> logout() async {
    await _auth.signOut();
    currentUser = null;
    notifyListeners();
  }
}