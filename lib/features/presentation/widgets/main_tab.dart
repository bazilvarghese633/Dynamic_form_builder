import 'package:dynamic_form_builder/features/domain/entities/form_entity.dart';
import 'package:dynamic_form_builder/features/presentation/widgets/sub_tab.dart';
import 'package:flutter/material.dart';

class MainTabs extends StatelessWidget {
  final List<FormEntity> forms;

  const MainTabs({super.key, required this.forms});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: forms.length,
      child: Column(
        children: [
          Container(
            color: Colors.grey.shade200,
            child: TabBar(
              isScrollable: true,
              labelColor: Colors.black,
              tabs: forms.map((form) {
                return Tab(text: form.name);
              }).toList(),
            ),
          ),

          Expanded(
            child: TabBarView(
              children: forms.map((form) {
                return SubTabs(genericData: form.genericData);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
