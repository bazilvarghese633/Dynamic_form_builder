import '../entities/form_entity.dart';
import '../repositories/form_repository.dart';

class GetFormData {
  final FormRepository repository;

  GetFormData(this.repository);

  Future<List<FormEntity>> call() {
    return repository.getForms();
  }
}
