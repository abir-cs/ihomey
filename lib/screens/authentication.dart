import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  /*Future<UserCredential> singIn({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
   */

  /*Future<UserCredential> creatAccount({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
   */

  Future<void> singOut() async {
    await firebaseAuth.signOut();
  }
  Future<String?> loginWithUsernameAndPassword({
    required String username,
    required String password,
  }) async {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

    try {
      // Step 1: Get email from Firestore using username
      final userDoc = await firestore.collection('users').doc(username).get();

      if (!userDoc.exists) return 'Username not found';

      final email = userDoc.data()!['email'];

      // Step 2: Sign in using email + password
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
        // Get the old username (you can use Firestore to fetch it if needed)
        //String oldUsername = user.displayName ?? user.email!.split('@')[0]; // You can replace this with the actual old username
        // Get current user
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          throw FirebaseAuthException(
            code: 'no-user',
            message: 'No authenticated user found.',
          );
        }

        // Get user's email
        String email = user.email!;

        // Query Firestore to find the document with that email
        final query = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (query.docs.isEmpty) {
          throw Exception('No user document found with email: $email');
        }

        // Get the username (document ID)
        String oldUsername = query.docs.first.id;

        // Step 1: Create a new document with the new username as the document ID
        await FirebaseFirestore.instance.collection('users')
            .doc(newUsername) // new document ID
            .set({
          'email': user.email,
        });

        // Step 2: Copy any other data (if needed) from the old document
        DocumentSnapshot oldUserDoc = await FirebaseFirestore.instance.collection('users')
            .doc(oldUsername) // old document ID
            .get();

        if (oldUserDoc.exists) {
          await FirebaseFirestore.instance.collection('users')
              .doc(newUsername) // Update new document with additional data if needed
              .update({
            'additionalField': oldUserDoc['additionalField'], // Example of copying additional fields
          });
        }

        // Step 3: Delete the old document
        try {
          await FirebaseFirestore.instance.collection('users')
              .doc("someone")
              .delete();
          print("Deleted successfully");
        } catch (e) {
          print("\n\n\n\n\n\n\nDelete failed: $e");
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
      // Step 1: Check if username already exists
      final doc = await firestore.collection('users').doc(username).get();
      if (doc.exists) {
        return 'Username already taken';
      }

      // Step 2: Create user in Firebase Auth
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Step 3: Save user data in Firestore under username
      await firestore.collection('users').doc(username).set({
        'email': email,
        //'uid': userCredential.user?.uid,
        // add more fields if needed
      });

      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'An error occurred';
    }
  }

}
