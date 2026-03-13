import 'package:dynamic_form_builder/core/color.dart';
import 'package:dynamic_form_builder/features/domain/entities/form_entity.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_bloc.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_state.dart';
import 'package:dynamic_form_builder/features/presentation/widgets/main_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormScreen extends StatelessWidget {
  const FormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<FormBloc, DynamicFormState>(
      listener: (context, state) {
        if (state is SubmissionActionSuccess) {
          _showSnack(
            context,
            state.message,
            green700,
            Icons.check_circle_rounded,
          );
        }
        if (state is FormError) {
          _showSnack(context, state.message, red700, Icons.error_rounded);
        }
      },
      child: BlocBuilder<FormBloc, DynamicFormState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: scaffbackgroundColor,
            appBar: AppBar(
              backgroundColor: appBarbackgroundColor,
              foregroundColor: whiteColor,
              elevation: 0,
              centerTitle: false,
              title: const Row(
                children: [
                  Icon(
                    Icons.dynamic_form_rounded,
                    size: 22,
                    color: Color(0xFF7C83FD),
                  ),
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
            ),
            body: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, DynamicFormState state) {
    if (state is FormLoading) {
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

    List<FormEntity>? forms;
    if (state is FormLoaded) forms = state.forms;
    if (state is FormSaved) forms = state.forms;
    if (state is SubmissionActionSuccess) forms = state.forms;
    if (state is FormError && state.forms != null) forms = state.forms;

    if (forms != null && forms.isNotEmpty) {
      return MainTabs(forms: forms);
    }

    return const Center(child: Text('No forms available'));
  }

  void _showSnack(
    BuildContext context,
    String msg,
    Color color,
    IconData icon,
  ) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: whiteColor, size: 18),
            const SizedBox(width: 10),
            Expanded(child: Text(msg, style: const TextStyle(fontSize: 14))),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
