import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seezme/core/utility/constans/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  get auth => _auth;
  Future<bool> isLoggedIn() async {
    return _auth.currentUser != null;
  }

  Future<String> getUsername() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userRef = _firestore.collection("users").doc(user.uid);
      final userDoc = await userRef.get();
      return userDoc.data()?["username"] as String? ?? "";
    }
    return "";
  }

  Future<String> getEmail() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userRef = _firestore.collection("users").doc(user.uid);
      final userDoc = await userRef.get();
      return userDoc.data()?["email"] as String? ?? "";
    }
    return "";
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _updateStatus(Status.statusAvailable);
      await initUserPresence();
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  Future<void> signOut() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _updateStatus(Status.statusOffline);
      }
      await _auth.signOut();
    } catch (e) {
      throw Exception("Logout failed: $e");
    }
  }

  Future<void> _updateStatus(String status) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userRef = _firestore.collection("users").doc(user.uid);
      await userRef.update({"status": status});
    }
  }

  Stream<String?> listenToStatus(String userId) {
    return _firestore
        .collection("users")
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.data()?["status"] as String?;
    });
  }

  Future<void> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = _auth.currentUser;
      if (user != null) {
        final userRef = _firestore.collection("users").doc(user.uid);
        String baseUsername = email.split("@").first;
        String username = await _generateUniqueUsername(baseUsername);
        await userRef.set({
          "uid": user.uid,
          "email": email,
          "username": username,
          "password": password,
          "status": Status.statusAvailable,
          "createdAt": Timestamp.now(),
        });
      }
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }

  Future<String> _generateUniqueUsername(String baseUsername) async {
    int suffix = 1;
    String username = "$baseUsername#$suffix";
    bool isUnique = false;

    while (!isUnique) {
      final querySnapshot = await _firestore
          .collection("users")
          .where("username", isEqualTo: username)
          .get();

      if (querySnapshot.docs.isEmpty) {
        isUnique = true;
      } else {
        suffix++;
        username = "$baseUsername#$suffix";
      }
    }

    return username;
  }

  Future<void> initUserPresence() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userStatusRef = _firestore.collection("users").doc(user.uid);

      _firestore.collection('.info/connected').doc().snapshots().listen((snap) {
        if (snap.exists) {
          userStatusRef.update({
            "status": Status.statusAvailable,
            "lastSeen": FieldValue.serverTimestamp(),
          });
        } else {
          userStatusRef.update({
            "status": Status.statusOffline,
            "lastSeen": FieldValue.serverTimestamp(),
          });
        }
      }, onError: (error) {
        print("Error setting user presence: $error");
      });
    }
  }
}
