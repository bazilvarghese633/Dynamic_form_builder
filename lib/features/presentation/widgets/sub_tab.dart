import 'package:dynamic_form_builder/features/domain/entities/form_entity.dart';
import 'package:dynamic_form_builder/features/presentation/widgets/question_widgets.dart';
import 'package:flutter/material.dart';

class SubTabs extends StatelessWidget {
  final List<GenericDataEntity> genericData;

  const SubTabs({super.key, required this.genericData});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: genericData.length,
      child: Column(
        children: [
          Container(
            color: Colors.grey.shade100,
            child: TabBar(
              isScrollable: true,
              labelColor: Colors.black,
              tabs: genericData.map((subTab) {
                return Tab(text: subTab.name);
              }).toList(),
            ),
          ),

          Expanded(
            child: TabBarView(
              children: genericData.map((subTab) {
                return ListView(
                  padding: const EdgeInsets.all(10),
                  children: subTab.questions.map((question) {
                    return QuestionWidget(question);
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
