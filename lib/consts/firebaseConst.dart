import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Firebase instances following naming conventions
final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

// Firestore collection name constant
const String usersCollection = "users";

// Reactive user stream to track auth changes (better than static currentUser)
Stream<User?> get userStream => auth.authStateChanges();

// Safe getter for current user
User? get currentUser => auth.currentUser;
