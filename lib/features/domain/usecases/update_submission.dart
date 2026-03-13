import '../../data/datasource/firestore_service.dart';

class UpdateSubmission {
  final FirestoreService _firestoreService;

  UpdateSubmission(this._firestoreService);

  Future<void> call({
    required String documentId,
    required Map<String, dynamic> answers,
  }) async {
    await _firestoreService.updateSubmission(
      documentId: documentId,
      answers: answers,
    );
  }
}
