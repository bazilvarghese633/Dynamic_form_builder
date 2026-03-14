import 'package:dynamic_form_builder/core/color.dart';
import 'package:dynamic_form_builder/features/domain/entities/form_entity.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_bloc.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_state.dart';
import 'package:dynamic_form_builder/features/presentation/utils/app_snackbar.dart';
import 'package:dynamic_form_builder/features/presentation/widgets/main_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormScreen extends StatelessWidget {
  const FormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<FormBloc, DynamicFormState>(
      listener: _handleState,
      child: BlocBuilder<FormBloc, DynamicFormState>(
        builder: (context, state) => Scaffold(
          backgroundColor: scaffbackgroundColor,
          appBar: _buildAppBar(),
          body: _buildBody(state),
        ),
      ),
    );
  }

  void _handleState(BuildContext context, DynamicFormState state) {
    if (state is SubmissionActionSuccess) {
      showSnack(context, state.message, green700, Icons.check_circle_rounded);
    }
    if (state is FormError) {
      showSnack(context, state.message, red700, Icons.error_rounded);
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: appBarbackgroundColor,
      foregroundColor: whiteColor,
      elevation: 0,
      centerTitle: false,
      title: const Row(
        children: [
          Icon(Icons.dynamic_form_rounded, size: 22, color: Color(0xFF7C83FD)),
          SizedBox(width: 10),
          Text(
            'FormBuilder',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(DynamicFormState state) {
    if (state is FormLoading) return _loadingView();

    final forms = _formsFrom(state);
    if (forms != null && forms.isNotEmpty) return MainTabs(forms: forms);

    return const Center(child: Text('No forms available'));
  }

  List<FormEntity>? _formsFrom(DynamicFormState state) {
    if (state is FormLoaded) return state.forms;
    if (state is FormSaved) return state.forms;
    if (state is SubmissionActionSuccess) return state.forms;
    if (state is FormError) return state.forms;
    return null;
  }

  Widget _loadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF7C83FD)),
          SizedBox(height: 16),
          Text(
            'Loading...',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
