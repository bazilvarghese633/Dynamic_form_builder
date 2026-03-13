import '../entities/form_entity.dart';

abstract class FormRepository {
  Future<List<FormEntity>> getForms();
}
