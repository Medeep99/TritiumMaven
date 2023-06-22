import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maven/common/dialog/timer_picker_dialog.dart';

import '../../../common/dialog/show_bottom_sheet_dialog.dart';
import '../../../common/widget/m_button.dart';
import '../../../database/database.dart';
import '../../../theme/widget/inherited_theme_widget.dart';
import '../../equipment/bloc/equipment/equipment_bloc.dart';

class ExerciseGroupMenu extends StatelessWidget {
  const ExerciseGroupMenu({Key? key,
    required this.exercise,
    required this.exerciseGroup,
    required this.onExerciseGroupUpdate,
    required this.onExerciseGroupDelete,
  }) : super(key: key);

  final Exercise exercise;
  final ExerciseGroup exerciseGroup;
  final ValueChanged<ExerciseGroup> onExerciseGroupUpdate;
  final Function() onExerciseGroupDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        exercise.equipment == Equipment.barbell ? MButton.tiled(
          onPressed: (){
            Navigator.pop(context);
            showBottomSheetDialog(
              context: context,
              child: BlocBuilder<EquipmentBloc, EquipmentState>(
                builder: (context, state) {
                  if(state.status == EquipmentStatus.loading) {
                    return const Center(heightFactor: 3,child: CircularProgressIndicator());
                  } else {
                    List<Bar> bars = state.bars;
                    return SizedBox(
                      child: Column(
                        children: [
                          ListView.builder(
                            itemCount: bars.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              Bar bar = bars[index];
                              return MButton.tiled(
                                onPressed: (){
                                  onExerciseGroupUpdate(exerciseGroup.copyWith(barId: bar.id));
                                  Navigator.pop(context);
                                },
                                leading: exerciseGroup.barId == bar.id ? Container(
                                  width: 20,
                                  alignment: Alignment.centerLeft,
                                  child: const Icon(
                                    Icons.check,
                                  ),
                                ) : Container(width: 20,),
                                title: bar.name,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              onClose: (){},
            );
          },
          leading: const Icon(
            Icons.fitness_center_rounded,
          ),
          title: 'Bar Type',
        ) : Container(),
        exercise.weightUnit != null ? MButton.tiled(
          onPressed: () {
            Navigator.pop(context);
            showBottomSheetDialog(
              context: context,
              child: ListView.builder(
                itemCount: WeightUnit.values.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  WeightUnit weightUnit = WeightUnit.values[index];
                  return MButton.tiled(
                    onPressed: (){
                      onExerciseGroupUpdate(exerciseGroup.copyWith(weightUnit: weightUnit));
                      Navigator.pop(context);
                    },
                    expand: false,
                    leading: exerciseGroup.weightUnit == weightUnit ? Container(
                      width: 20,
                      alignment: Alignment.centerLeft,
                      child: const Icon(
                        Icons.check,
                      ),
                    ) : Container(width: 20,),
                    title: weightUnit.name
                  );
                },
              )
            );
          },
          leading: const Icon(Icons.scale),
          title: 'Weight Unit',
          trailing: Text(
            exerciseGroup.weightUnit?.name.toString() ?? '',
            style: T(context).textStyle.subtitle1,
          ),
        ) : Container(),
        exercise.distanceUnit != null ? MButton.tiled(
          onPressed: () {
            Navigator.pop(context);
            showBottomSheetDialog(
              context: context,
              child: ListView.builder(
                itemCount: DistanceUnit.values.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DistanceUnit distanceUnit = DistanceUnit.values[index];
                  return MButton.tiled(
                    onPressed: (){
                      onExerciseGroupUpdate(exerciseGroup.copyWith(distanceUnit: distanceUnit));
                      Navigator.pop(context);
                    },
                    expand: false,
                    leading: exerciseGroup.distanceUnit == distanceUnit ? Container(
                      width: 20,
                      alignment: Alignment.centerLeft,
                      child: const Icon(
                        Icons.check,
                      ),
                    ) : Container(width: 20,),
                    title: distanceUnit.name
                  );
                },
              )
            );
          },
          leading: const Icon(Icons.directions_run),
          title: 'Distance Unit',
          trailing: Text(
            exerciseGroup.distanceUnit!.name.toString(),
            style: T(context).textStyle.subtitle1,
          ),
        ) : Container(),
        MButton.tiled(
          onPressed: (){
            Navigator.pop(context);
            showBottomSheetDialog(
              context: context,
              child: TimedPickerDialog(
                initialValue: exerciseGroup.timer,
                onSubmit: (value) {
                  onExerciseGroupUpdate(exerciseGroup.copyWith(timer: value));
                },
              ),
              onClose: (){}
            );
          },
          leading: Icon(
            Icons.timer,
          ),
          trailing: Text(
            '${exerciseGroup.timer.toString()}',
            style: T(context).textStyle.subtitle1,
          ),
          title: 'Rest Timer',
        ),
        MButton.tiled(
          onPressed: (){
            onExerciseGroupDelete();
            Navigator.pop(context);
          },
          leading: Icon(
            Icons.delete_rounded,
            color: T(context).color.error,
          ),
          title: 'Remove',
        ),
      ],
    );
  }
}
