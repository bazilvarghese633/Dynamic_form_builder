import 'package:dynamic_form_builder/features/data/datasource/form_local_datasource.dart';
import 'package:dynamic_form_builder/features/data/repositiories/form_repository_impl.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_bloc.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_event.dart';
import 'package:dynamic_form_builder/features/presentation/screen/form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/domain/usecases/get_form_data.dart';

void main() {
  final datasource = FormLocalDatasource();
  final repository = FormRepositoryImpl(datasource);
  final usecase = GetFormData(repository);

  runApp(MyApp(usecase));
}

class MyApp extends StatelessWidget {
  final GetFormData usecase;
  const MyApp(this.usecase, {super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: BlocProvider(
        create: (_) => FormBloc(usecase)..add(LoadFormEvent()),
        child: FormScreen(),
      ),
    );
  }
}
