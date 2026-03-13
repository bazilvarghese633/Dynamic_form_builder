import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveFormSubmission({
    required String formName,
    required String sectionName,
    required Map<String, dynamic> answers,
  }) async {
    try {
      final docRef = await _firestore.collection('form_submissions').add({
        'formName': formName,
        'sectionName': sectionName,
        'answers': _sanitizeAnswers(answers),
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('✅ Form saved with ID: ${docRef.id}');
    } catch (e) {
      print('❌ Error saving form: $e');
      throw Exception('Failed to save form submission: $e');
    }
  }

  Future<void> deleteSubmission(String documentId) async {
    try {
      await _firestore.collection('form_submissions').doc(documentId).delete();
      print('✅ Deleted: $documentId');
    } catch (e) {
      throw Exception('Failed to delete submission: $e');
    }
  }

  Future<void> updateSubmission({
    required String documentId,
    required Map<String, dynamic> answers,
  }) async {
    try {
      await _firestore.collection('form_submissions').doc(documentId).update({
        'answers': _sanitizeAnswers(answers),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print('✅ Updated: $documentId');
    } catch (e) {
      throw Exception('Failed to update submission: $e');
    }
  }

  Stream<QuerySnapshot> getFormSubmissions(
    String formName,
    String sectionName,
  ) {
    return _firestore
        .collection('form_submissions')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// Converts DateTime values to ISO 8601 strings so Firestore stores them
  /// as plain strings that round-trip cleanly back to DateTime.
  Map<String, dynamic> _sanitizeAnswers(Map<String, dynamic> answers) {
    return answers.map((key, value) {
      if (value is DateTime) {
        return MapEntry(key, value.toIso8601String());
      }
      return MapEntry(key, value);
    });
  }
}
