import 'package:dynamic_form_builder/features/domain/entities/form_entity.dart';
import 'package:dynamic_form_builder/features/presentation/widgets/subtab/pill_tab.dart';
import 'package:dynamic_form_builder/features/presentation/widgets/subtab/section_page.dart';
import 'package:flutter/material.dart';

class SubTabs extends StatelessWidget {
  final String formName;
  final List<GenericDataEntity> genericData;

  const SubTabs({super.key, required this.formName, required this.genericData});

  @override
  Widget build(BuildContext context) {
    if (genericData.isEmpty) {
      return const Center(child: Text('No sections available'));
    }

    if (genericData.length == 1) {
      return SectionPage(formName: formName, section: genericData.first);
    }

    return DefaultTabController(
      length: genericData.length,
      child: Column(
        children: [
          _PillBar(genericData: genericData),
          Expanded(
            child: TabBarView(
              children: genericData
                  .map((s) => SectionPage(formName: formName, section: s))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PillBar extends StatelessWidget {
  final List<GenericDataEntity> genericData;

  const _PillBar({required this.genericData});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A2E),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      child: TabBar(
        isScrollable: false,
        tabAlignment: TabAlignment.fill,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: const Color(0xFF7C83FD),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C83FD).withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 2,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white54,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13,
          letterSpacing: 0.3,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 13,
        ),
        splashBorderRadius: BorderRadius.circular(30),
        labelPadding: EdgeInsets.zero,
        tabs: genericData.map((s) => PillTab(label: s.name)).toList(),
      ),
    );
  }
}
