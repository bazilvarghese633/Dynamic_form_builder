import '../../data/datasource/firestore_service.dart';

class DeleteSubmission {
  final FirestoreService _firestoreService;

  DeleteSubmission(this._firestoreService);

  Future<void> call(String documentId) async {
    await _firestoreService.deleteSubmission(documentId);
  }
}
