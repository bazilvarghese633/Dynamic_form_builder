import '../../domain/entities/form_entity.dart';

class FormModel extends FormEntity {
  FormModel({required super.id, required super.name, required super.genericData});

  factory FormModel.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String;
    return FormModel(
      id: name.toLowerCase().replaceAll(' ', '_'),
      name: name,
      genericData: (json['generic_data'] as List)
          .map((e) => GenericDataModel.fromJson(e))
          .toList(),
    );
  }
}

class GenericDataModel extends GenericDataEntity {
  GenericDataModel({required super.name, required super.questions});

  factory GenericDataModel.fromJson(Map<String, dynamic> json) {
    return GenericDataModel(
      name: json['generic_data_name'],
      questions: (json['generic_data_subData'] as List)
          .map((e) => QuestionModel.fromJson(e))
          .toList(),
    );
  }
}

class QuestionModel extends QuestionEntity {
  QuestionModel({
    required super.uid,
    required super.componentName,
    required super.multipleSelection,
    required super.options,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      uid: json['uid'],
      componentName: json['component_name'],
      multipleSelection: json['multiple_selection'] ?? false,
      options: (json['component_data'] as List)
          .map((e) => OptionModel.fromJson(e))
          .toList(),
    );
  }
}

class OptionModel extends OptionEntity {
  OptionModel({
    required super.name,
    super.type,
    super.hint,
    super.placeholder,
    super.maxLength,
    super.subData,
    super.dropDownOptions,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      name: json['name'] ?? "",
      type: json['type'],
      hint: json['hint'],
      placeholder: json['placeholder'],
      maxLength: json['max_length'],

      dropDownOptions: json['drop_down'] != null
          ? (json['drop_down'] as List)
                .map((e) => e['component_info'] as String)
                .toList()
          : null,

      subData: json['sub_data'] != null
          ? (json['sub_data'] as List)
                .map((e) => OptionModel.fromJson(e))
                .toList()
          : null,
    );
  }
}
