import '../../domain/entities/form_entity.dart';
import '../../domain/repositories/form_repository.dart';
import '../datasource/form_local_datasource.dart';

class FormRepositoryImpl implements FormRepository {
  final FormLocalDatasource datasource;

  FormRepositoryImpl(this.datasource);

  @override
  Future<List<FormEntity>> getForms() {
    return datasource.getForms();
  }
}
