import 'package:dynamic_form_builder/features/presentation/bloc/form_bloc.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_state.dart';
import 'package:dynamic_form_builder/features/presentation/widgets/question_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormScreen extends StatelessWidget {
  const FormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dynamic Form')),
      body: BlocBuilder<FormBloc, DynamicFormState>(
        builder: (context, state) {
          if (state is FormLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FormLoaded) {
            final forms = state.forms;

            return DefaultTabController(
              length: forms.length,
              child: Column(
                children: [
                  TabBar(tabs: forms.map((e) => Tab(text: e.name)).toList()),
                  Expanded(
                    child: TabBarView(
                      children: forms.map((tab) {
                        return ListView(
                          children: tab.genericData.map((subTab) {
                            return ExpansionTile(
                              title: Text(subTab.name),
                              children: subTab.questions
                                  .map((q) => QuestionWidget(q))
                                  .toList(),
                            );
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
