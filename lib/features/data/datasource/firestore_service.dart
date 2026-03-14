import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dynamic_form_builder/core/utils/device_id_service.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Returns the collection ref scoped to this device only.
  /// Path: device_submissions/{deviceId}/form_submissions
  Future<CollectionReference> _collection() async {
    final deviceId = await DeviceIdService.getDeviceId();
    return _firestore
        .collection('device_submissions')
        .doc(deviceId)
        .collection('form_submissions');
  }

  Future<void> saveFormSubmission({
    required String formName,
    required String sectionName,
    required Map<String, dynamic> answers,
  }) async {
    final col = await _collection();
    await col.add({
      'formName': formName,
      'sectionName': sectionName,
      'answers': _sanitize(answers),
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateSubmission({
    required String documentId,
    required Map<String, dynamic> answers,
  }) async {
    final col = await _collection();
    await col.doc(documentId).update({
      'answers': _sanitize(answers),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteSubmission(String documentId) async {
    final col = await _collection();
    await col.doc(documentId).delete();
  }

  Future<Stream<QuerySnapshot>> getSubmissionsStream() async {
    final col = await _collection();
    return col.orderBy('timestamp', descending: true).snapshots();
  }

  /// Converts DateTime → ISO string so Firestore stores it
  /// as a parseable string inside the answers map.
  Map<String, dynamic> _sanitize(Map<String, dynamic> answers) {
    return answers.map((key, value) {
      if (value is DateTime) return MapEntry(key, value.toIso8601String());
      return MapEntry(key, value);
    });
  }
}
