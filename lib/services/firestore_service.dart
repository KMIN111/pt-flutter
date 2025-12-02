import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a new user document to Firestore during registration
  Future<void> addUser(String uid, String name, String email) async {
    await _db.collection('users').doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
      'conversationCount': 0,
      'averageHealthScore': 0,
      'healingContentCount': 0,
    });
  }

  // Get user data
  Stream<Map<String, dynamic>?> getUserStream(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data();
      }
      return null;
    });
  }

  // Update user mood score
  Future<void> updateMoodScore(String uid, int moodScore) async {
    await _db.collection('users').doc(uid).collection('mood_scores').add({
      'score': moodScore,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Get user mood scores
  Stream<List<Map<String, dynamic>>> getMoodScoresStream(String uid) {
    return _db.collection('users').doc(uid).collection('mood_scores')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => doc.data())
          .where((data) => data['timestamp'] != null && data['score'] != null)
          .toList();
    });
  }

  // Update user mental health score
  Future<void> updateMentalHealthScore(String uid, int mentalHealthScore) async {
    await _db.collection('users').doc(uid).collection('mental_health_scores').add({
      'score': mentalHealthScore,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Get user mental health scores
  Stream<List<Map<String, dynamic>>> getMentalHealthScoresStream(String uid) {
    return _db.collection('users').doc(uid).collection('mental_health_scores')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // Update user sleep time
  Future<void> addSleepRecord(String uid, double duration) async {
    await _db.collection('users').doc(uid).collection('sleep_records').add({
      'duration': duration,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Get user sleep scores
  Stream<List<Map<String, dynamic>>> getSleepScoresStream(String uid) {
    return _db.collection('users').doc(uid).collection('sleep_records')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => doc.data())
          .where((data) => data['timestamp'] != null && data['duration'] != null)
          .toList();
    });
  }
}