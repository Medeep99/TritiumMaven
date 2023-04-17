import 'package:Maven/feature/exercise/model/exercise_equipment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';

import '../../../../theme/m_themes.dart';
import '../../../common/dialog/show_bottom_sheet_dialog.dart';
import '../../../common/widget/m_button.dart';
import '../../../database/model/exercise.dart';
import '../../m_keyboard/widget/m_keyboard.dart';
import '../../workout/widget/active_exercise_row.dart';
import '../model/exercise_set.dart';

class ExerciseSetWidget extends StatefulWidget {

  const ExerciseSetWidget({Key? key,
    required this.index,
    this.barId,
    required this.exercise,
    required this.exerciseSet,
    required this.onExerciseSetUpdate,
    required this.checkboxEnabled,
    required this.hintsEnabled,
  }) : super(key: key);

  final int index;
  final int? barId;
  final Exercise exercise;
  final ExerciseSet exerciseSet;
  final ValueChanged<ExerciseSet> onExerciseSetUpdate;
  final bool checkboxEnabled;
  final bool hintsEnabled;

  @override
  State<ExerciseSetWidget> createState() => _ExerciseSetWidgetState();
}

class _ExerciseSetWidgetState extends State<ExerciseSetWidget> {

  late ExerciseSet exerciseSet;

  static const Duration _animationSpeed = Duration(milliseconds: 250);

  bool _isChecked = false;

  final TextEditingController option2EditingController = TextEditingController();

  bool _shake = false;


  void _updateExerciseSet() {
    widget.onExerciseSetUpdate(exerciseSet.copyWith(
      option2: option2EditingController.text.isEmpty ? 0 : int.parse(option2EditingController.text),
      checked: widget.checkboxEnabled ? _isChecked ? 1 : 0 : null
    ));
  }

  @override
  void initState() {
    exerciseSet = widget.exerciseSet;
    option2EditingController.text = exerciseSet.option2 == null ? '' : exerciseSet.option2 == 0 ? '' : exerciseSet.option2.toString();
    _isChecked = exerciseSet.checked == 1 ? true : false;
    option2EditingController.addListener(() => _updateExerciseSet());
    super.initState();
  }

  @override
  void dispose() {
    option2EditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: _animationSpeed,
      height: 44,
      color: _isChecked ? mt(context).activeExerciseSet.completeColor : mt(context).color.background,
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: ActiveExerciseRow.build(
        set: MButton(
          onPressed: () {},
          expand: false,
          height: 35,
          backgroundColor: Colors.transparent,
          child: Text(
            widget.index.toString(),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: mt(context).color.primary,
            ),
          ),
        ),

        previous: MButton(
          onPressed: () {

          },
          expand: false,
          height: 35,
          backgroundColor: Colors.transparent,
          child: Text(
            '-',
            style: mt(context).textStyle.subtitle1,
          ),
        ),

        option1: MButton(
          height: 30,
          expand: false,
          backgroundColor: _isChecked ? mt(context).activeExerciseSet.completeColor : mt(context).textField.backgroundColor,
          child: Text(
            exerciseSet.option1 == 0 ? '' : exerciseSet.option1.toString(),
            style: mt(context).textStyle.body1,
          ),
          onPressed: () {
            showBottomSheetDialog(
              context: context,
              child: MKeyboard(
                barId: widget.barId,
                exerciseEquipment: widget.exercise.exerciseEquipment,
                value: exerciseSet.option1 == 0 ? '' : exerciseSet.option1.toString(),
                onValueChanged: (p0) {
                  var nice = exerciseSet.copyWith(option1: p0.isEmpty ? 0 : int.parse(p0));
                  exerciseSet = nice;
                  widget.onExerciseSetUpdate(nice);
                },
              ),
              onClose: () {},
            );
          },
        ),


        option2: widget.exercise.exerciseType.exerciseTypeOption2 != null ? MButton(
          height: 30,
          expand: false,
          backgroundColor: _isChecked ? mt(context).activeExerciseSet.completeColor : mt(context).textField.backgroundColor,
          child: Text(
            exerciseSet.option2 == 0 ? '' : exerciseSet.option2.toString(),
            style: mt(context).textStyle.body1,
          ),
          onPressed: () {
            showBottomSheetDialog(
              context: context,
              onClose: () {
                print('closed');
              },
              height: 300,
              child: MKeyboard(
                barId: widget.barId,
                exerciseEquipment: ExerciseEquipment.none,
                value: exerciseSet.option2 == 0 ? '' : exerciseSet.option2.toString(),
                onValueChanged: (p0) {
                  var nice = exerciseSet.copyWith(option2: p0.isEmpty ? 0 : int.parse(p0));
                  exerciseSet = nice;
                  widget.onExerciseSetUpdate(nice);
                },
              ),
            );
          },
        ) : null,

        checkbox: widget.checkboxEnabled ? ShakeWidget(
          shakeConstant: ShakeHorizontalConstant2(),
          duration: const Duration(milliseconds: 2000),
          autoPlay: _shake,
          child: SizedBox(
            height: 38,
            child: Transform.scale(
              scale: 1.8,
              child: Checkbox(
                value: _isChecked,
                onChanged: (value) async {
                /*  if(exerciseSet.option2 == null) {
                    if(option1EditingController.text.isEmpty) {
                      setState(() {_shake = true;});
                      await Future.delayed(const Duration(milliseconds: 500));
                      setState(() {_shake = false;});
                      return;
                    }
                  } else {
                    if(option1EditingController.text.isEmpty || option2EditingController.text.isEmpty) {
                      setState(() {_shake = true;});
                      await Future.delayed(const Duration(milliseconds: 500));
                      setState(() {_shake = false;});
                      return;
                    }
                  }*/

                  setState(() {
                    _isChecked = !_isChecked;
                  });
                  _updateExerciseSet();



                },
                fillColor: _isChecked ? MaterialStateProperty.all<Color>(
                    const Color(0XFF2FCD71)) : MaterialStateProperty.all<Color>(mt(context).color.secondary
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ) : null,

      ),
    );
  }
}
