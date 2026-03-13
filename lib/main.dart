import 'package:dynamic_form_builder/features/data/datasource/firestore_service.dart';
import 'package:dynamic_form_builder/features/data/datasource/form_local_datasource.dart';
import 'package:dynamic_form_builder/features/data/repositiories/form_repository_impl.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_bloc.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_event.dart';
import 'package:dynamic_form_builder/features/presentation/screen/form_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/domain/usecases/get_form_data.dart';
import 'features/domain/usecases/save_form_data.dart';
import 'features/domain/usecases/delete_submission.dart';
import 'features/domain/usecases/update_submission.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final datasource = FormLocalDatasource();
  final repository = FormRepositoryImpl(datasource);
  final getFormDataUseCase = GetFormData(repository);
  final firestoreService = FirestoreService();
  final saveFormDataUseCase = SaveFormData(firestoreService);
  final deleteSubmissionUseCase = DeleteSubmission(firestoreService);
  final updateSubmissionUseCase = UpdateSubmission(firestoreService);

  runApp(MyApp(
    getFormDataUseCase, 
    saveFormDataUseCase,
    deleteSubmissionUseCase,
    updateSubmissionUseCase,
  ));
}

class MyApp extends StatelessWidget {
  final GetFormData getFormDataUseCase;
  final SaveFormData saveFormDataUseCase;
  final DeleteSubmission deleteSubmissionUseCase;
  final UpdateSubmission updateSubmissionUseCase;
  
  const MyApp(
    this.getFormDataUseCase, 
    this.saveFormDataUseCase,
    this.deleteSubmissionUseCase,
    this.updateSubmissionUseCase,
    {super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: BlocProvider(
        create: (_) => FormBloc(
          getFormDataUseCase, 
          saveFormDataUseCase,
          deleteSubmissionUseCase,
          updateSubmissionUseCase,
        )..add(LoadFormEvent()),
        child: const FormScreen(),
      ),
    );
  }
}
