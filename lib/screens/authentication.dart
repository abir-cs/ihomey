import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';



class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<void> singOut() async {
    final auth = FirebaseAuth.instance;
    await auth.signOut();
  }

  Future<String?> login({
    required String username,
    required String password,
  }) async {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

    try {
      //Get email from Firestore using username
      final user = await firestore.collection('users').doc(username).get();

      if (!user.exists) return 'Username not found';

      final email = user.data()!['email'];

      //Sign in using email + password
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // success
    } catch (e) {
      return 'Login failed: ${e.toString()}';
    }
  }
  Future<bool> isUsernameUnique(String newUsername) async {
    var userDoc = await FirebaseFirestore.instance.collection('users')
        .where('username', isEqualTo: newUsername)
        .get();
    return userDoc.docs.isEmpty; // If no document found, username is unique
  }

  Future<void> updateUsername(String newUsername) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User is not logged in");
      }
      // Check if the new username is unique
      if (await isUsernameUnique(newUsername)) {
        // Get user's email
        String email = user.email!;
        // Query Firestore to find the document with that email
        final query = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();
        // Get the username (document ID)
        String oldUsername = query.docs.first.id;
        // Create a new document with the new username as the document ID
        await FirebaseFirestore.instance.collection('users')
            .doc(newUsername) // new document ID
            .set({
          'email': user.email,
        });
        // Delete the old document
        try {
          await FirebaseFirestore.instance.collection('users')
              .doc(oldUsername)
              .delete();
          print(" Deleted successfully");
        } catch (e) {
          print(" Delete failed: $e");
        }
        print("Username updated successfully!");
      } else {
        print("Username is already taken");
      }
    } catch (e) {
      print("Error updating username: $e");
    }
  }
  Future<String?> createAccount({
    required String username,
    required String email,
    required String password,
  }) async {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    try {
      // Check if username already exists
      final doc = await firestore.collection('users').doc(username).get();
      if (doc.exists) {
        return 'Username already taken';
      }
      // Create user in Firebase Auth
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Save user data in Firestore under username
      await firestore.collection('users').doc(username).set({
        'email': email,
      });

      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'An error occurred';
    }
  }
  Future<void> updatetheEmail(String username, String newEmail, String password) async {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

    try {
      // Get the currently signed-in user
      User? user = auth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'no-user',
          message: 'No user is currently signed in.',
        );
      }
      // Get the current email to create credentials
      String? currentEmail = user.email;
      if (currentEmail == null) {
        throw FirebaseAuthException(
          code: 'missing-email',
          message: 'Current user email not found.',
        );
      }
      // Re-authenticate the user
      AuthCredential credential = EmailAuthProvider.credential(
        email: currentEmail,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);

      //Update email in Firebase Authentication
      await user.updateEmail(newEmail);

      await firestore.collection('users').doc(username).update({
        'email': newEmail,
      });

      print('Email updated successfully in both Auth and Firestore.');
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth error: ${e.code} - ${e.message}');
      rethrow;
    } on FirebaseException catch (e) {
      print('Firestore error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error: $e');
      rethrow;
    }
  }
  Future<String?> getUsernameFromEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User is not logged in");
      }

      final email = user.email;
      if (email == null) {
        throw Exception("User email is not available");
      }

      // Query Firestore to find the document with the matching email
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception("No user document found with email: $email");
      }

      // The document ID is the username
      final username = querySnapshot.docs.first.id;
      return username;
    } catch (e) {
      print("Error fetching username: $e");
      return null;
    }
  }

}
