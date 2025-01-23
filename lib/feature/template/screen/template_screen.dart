import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maven/common/common.dart';
// import 'package:maven/feature/program/screen/program_builder_screen.dart';

// import '../../program/view/program_list_view.dart';
import '../../theme/theme.dart';
import '../../workout/workout.dart';
import '../template.dart';

/// Screen which manages templates, workouts, and programs
class TemplateScreen extends StatefulWidget {
  /// Creates a screen for managing templates, workouts, and programs
  const TemplateScreen({Key? key}) : super(key: key);

  @override
  State<TemplateScreen> createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {
  List<Widget> hey = [
    SliverToBoxAdapter(
      child: Container(
        color: Colors.red,
        height: 50,
        width: 50,
      ),
    )
  ];
  @override
  Widget build(BuildContext context) {
    return TitledScaffold(
      title: 'Workout',
      slivers: [
        const Heading(
          title: 'Quick Start',
          size: HeadingSize.small,
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton(
                  onPressed: () {
                    context.read<WorkoutBloc>().add(const WorkoutStateEmpty());
                  },
                  child: const Text(
                    'Start an Empty Workout',
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: T(context).color.surface,
                          foregroundColor: T(context).color.primary,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoutineEditScreen(
                                onSubmit: (routine, exerciseList) {
                                  context.read<TemplateBloc>().add(
                                        TemplateCreate(
                                          routine: routine,
                                          exerciseList: exerciseList,
                                        ),
                                      );
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.post_add,
                        ),
                        label: const Text(
                          'Create Workout',
                        ),
                      ),
                    ),
                   
                  ],
                ),
              ],
            ),
          ]),
        ),
     
        const Heading(
          title: 'Templates',
        ),
        const TemplateListView(),
   
      ],
    );
  }
}
