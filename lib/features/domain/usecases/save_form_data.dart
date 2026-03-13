import '../../data/datasource/firestore_service.dart';

class SaveFormData {
  final FirestoreService _firestoreService;

  SaveFormData(this._firestoreService);

  Future<void> call({
    required String formName,
    required String sectionName,
    required Map<String, dynamic> answers,
  }) async {
    await _firestoreService.saveFormSubmission(
      formName: formName,
      sectionName: sectionName,
      answers: answers,
    );
  }
}
