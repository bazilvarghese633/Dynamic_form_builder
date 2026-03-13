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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: const Color(0xFF1A1A2E),
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: const Color(0xFF7C83FD),
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white38,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                letterSpacing: 0.4,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              tabs: forms.map((f) => Tab(text: f.name.toUpperCase())).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: forms
                  .map(
                    (f) =>
                        SubTabs(formName: f.name, genericData: f.genericData),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
