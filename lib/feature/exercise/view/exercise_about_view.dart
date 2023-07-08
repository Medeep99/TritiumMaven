import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../../../common/common.dart';
import '../../../database/database.dart';
import '../../../theme/theme.dart';
import '../../equipment/equipment.dart';
import '../../muscle/muscle.dart';
import '../exercise.dart';

class ExerciseDetailView extends StatefulWidget {
  const ExerciseDetailView({
    super.key,
    required this.exercise,
  });

  final Exercise exercise;

  @override
  State<ExerciseDetailView> createState() => _ExerciseDetailViewState();
}

class _ExerciseDetailViewState extends State<ExerciseDetailView> {
  late final VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.asset(widget.exercise.videoPath)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized
        setState(() {
          _controller.setLooping(true);
          _controller.play();
        });
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const Heading(
          title: 'Video',
          side: true,
          size: HeadingSize.medium,
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: T(context).space.large,
          ),
          sliver: SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: T(context).color.outline,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadiusDirectional.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadiusDirectional.circular(12),
                child: _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : Container(
                        height: 200,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      ),
              ),
            ),
          ),
        ),
        const Heading(
          title: 'Details',
          side: true,
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: T(context).space.large),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Material(
                  color: T(context).color.surface,
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MuscleSelectionScreen(
                                muscle: widget.exercise.muscle,
                              ),
                            ),
                          ).then((value) {
                            if (value != null) {
                              context.read<ExerciseBloc>().add(ExerciseUpdate(exercise: widget.exercise.copyWith(muscle: value)));
                            }
                          });
                        },
                        leading: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.monitor_heart,
                            ),
                          ],
                        ),
                        title: Text(
                          'Muscle',
                          style: T(context).textStyle.bodyLarge,
                        ),
                        trailing: Text(
                          widget.exercise.muscle.name,
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MuscleGroupSelectionScreen(
                                muscleGroup: widget.exercise.muscleGroup,
                              ),
                            ),
                          ).then((value) {
                            if (value != null) {
                              context.read<ExerciseBloc>().add(ExerciseUpdate(
                                    exercise: widget.exercise.copyWith(muscleGroup: value),
                                  ));
                            }
                          });
                        },
                        leading: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.health_and_safety,
                            ),
                          ],
                        ),
                        title: Text(
                          'Muscle Group',
                          style: T(context).textStyle.bodyLarge,
                        ),
                        trailing: Text(
                          widget.exercise.muscleGroup.name.capitalize,
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          showBottomSheetDialog(
                              context: context,
                              child: TimedPickerDialog(
                                initialValue: widget.exercise.timer,
                                onSubmit: (value) {
                                  context.read<ExerciseBloc>().add(ExerciseUpdate(exercise: widget.exercise.copyWith(timer: value)));
                                },
                              ),
                              onClose: () {});
                        },
                        leading: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.timer,
                            ),
                          ],
                        ),
                        title: Text(
                          'Timer',
                          style: T(context).textStyle.bodyLarge,
                        ),
                        trailing: Text(
                          widget.exercise.timer.toString(),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EquipmentSelectionScreen(
                                equipment: widget.exercise.equipment,
                              ),
                            ),
                          ).then((value) {
                            if (value != null) {
                              context.read<ExerciseBloc>().add(ExerciseUpdate(exercise: widget.exercise.copyWith(equipment: value)));
                            }
                          });
                        },
                        leading: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.category,
                            ),
                          ],
                        ),
                        title: Text(
                          'Equipment',
                          style: T(context).textStyle.bodyLarge,
                        ),
                        trailing: Text(
                          widget.exercise.equipment.name.capitalize,
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExerciseTypeSelectionScreen(
                                exerciseTypes: widget.exercise.fields.map((e) => e.type).toList(),
                              ),
                            ),
                          ).then((value) {
                            // TODO: Implement different types in exercise
                          });
                        },
                        leading: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.tune,
                            ),
                          ],
                        ),
                        title: Text(
                          'Type',
                          style: T(context).textStyle.bodyLarge,
                        ),
                        trailing: Text(
                          widget.exercise.fields.map((obj) => obj.type.name.capitalize).join(' | '),
                        ),
                      ),
                      if (widget.exercise.weightUnit != null)
                        ListTile(
                          onTap: () {
                            showBottomSheetDialog(
                              context: context,
                              child: ListDialog(
                                children: List.generate(
                                  WeightUnit.values.length,
                                  (index) {
                                    return ListTile(
                                      onTap: () {
                                        context.read<ExerciseBloc>().add(ExerciseUpdate(
                                              exercise: widget.exercise.copyWith(
                                                weightUnit: WeightUnit.values[index],
                                              ),
                                            ));
                                        Navigator.pop(context);
                                      },
                                      title: Text(
                                        WeightUnit.values[index].name,
                                      ),
                                      trailing: widget.exercise.weightUnit == WeightUnit.values[index]
                                          ? const Icon(
                                              Icons.check_outlined,
                                            )
                                          : null,
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                          leading: const Icon(
                            Icons.scale,
                          ),
                          title: Text(
                            'Weight Unit',
                            style: T(context).textStyle.bodyLarge,
                          ),
                          trailing: Text(
                            widget.exercise.weightUnit!.name.toString().capitalize,
                          ),
                        ),
                      if (widget.exercise.distanceUnit != null)
                        ListTile(
                          onTap: () {
                            showBottomSheetDialog(
                              context: context,
                              child: ListDialog(
                                children: List.generate(
                                  DistanceUnit.values.length,
                                      (index) {
                                    return ListTile(
                                      onTap: () {
                                        context.read<ExerciseBloc>().add(ExerciseUpdate(
                                          exercise: widget.exercise.copyWith(
                                            distanceUnit: DistanceUnit.values[index],
                                          ),
                                        ));
                                        Navigator.pop(context);
                                      },
                                      title: Text(
                                        DistanceUnit.values[index].name,
                                      ),
                                      trailing: widget.exercise.distanceUnit == DistanceUnit.values[index]
                                          ? const Icon(
                                        Icons.check_outlined,
                                      )
                                          : null,
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                          leading: const Icon(
                            Icons.directions_run,
                          ),
                          title: Text(
                            'Distance Unit',
                            style: T(context).textStyle.bodyLarge,
                          ),
                          trailing: Text(
                            widget.exercise.distanceUnit!.name.toString().capitalize,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: T(context).space.large,
          ),
        )
      ],
    );
  }
}
