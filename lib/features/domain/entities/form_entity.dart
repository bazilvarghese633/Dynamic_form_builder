class FormEntity {
  final String id;
  final String name;
  final List<GenericDataEntity> genericData;

  FormEntity({required this.id, required this.name, required this.genericData});
}

class GenericDataEntity {
  final String name;
  final List<QuestionEntity> questions;

  GenericDataEntity({required this.name, required this.questions});
}

class QuestionEntity {
  final String uid;
  final String componentName;
  final bool multipleSelection;
  final List<OptionEntity> options;

  QuestionEntity({
    required this.uid,
    required this.componentName,
    required this.multipleSelection,
    required this.options,
  });
}

class OptionEntity {
  final String name;
  final String? type;
  final String? hint;
  final int? maxLength;
  final String? placeholder;

  final List<OptionEntity>? subData;

  final List<String>? dropDownOptions;

  OptionEntity({
    required this.name,
    this.type,
    this.hint,
    this.maxLength,
    this.placeholder,
    this.subData,
    this.dropDownOptions,
  });
}
