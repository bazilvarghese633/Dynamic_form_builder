import 'package:dynamic_form_builder/features/domain/entities/form_entity.dart';
import 'package:dynamic_form_builder/features/presentation/bloc/form_bloc.dart';
import 'package:dynamic_form_builder/features/presentation/screen/add_entry_screen.dart';

import 'package:dynamic_form_builder/features/presentation/widgets/saved_submissions_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      return _SectionPage(formName: formName, section: genericData.first);
    }

    return DefaultTabController(
      length: genericData.length,
      child: Column(
        children: [
          Container(
            color: const Color(0xFF22223B),
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: const Color(0xFFB5B9FF),
              indicatorWeight: 2,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: const Color(0xFFB5B9FF),
              unselectedLabelColor: Colors.white38,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              tabs: genericData.map((s) => Tab(text: s.name)).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: genericData
                  .map((s) => _SectionPage(formName: formName, section: s))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionPage extends StatelessWidget {
  final String formName;
  final GenericDataEntity section;

  const _SectionPage({required this.formName, required this.section});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: SavedSubmissionsWidget(
        formName: formName,
        sectionName: section.name,
        questions: section.questions,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final bloc = context.read<FormBloc>();
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, animation, __) => BlocProvider.value(
                value: bloc,
                child: AddEntryScreen(formName: formName, section: section),
              ),
              transitionsBuilder: (_, animation, __, child) {
                final slide =
                    Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      ),
                    );
                return SlideTransition(position: slide, child: child);
              },
            ),
          );
        },
        backgroundColor: const Color(0xFF7C83FD),
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded, size: 22),
        label: const Text(
          'New Entry',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
    );
  }
}
