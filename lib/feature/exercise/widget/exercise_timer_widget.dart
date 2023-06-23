import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maven/common/dialog/show_bottom_sheet_dialog.dart';
import 'package:maven/common/util/general_utils.dart';

import '../../../common/dialog/timer_picker_dialog.dart';
import '../../../common/model/timed.dart';
import '../../../common/widget/m_button.dart';
import '../../../theme/widget/inherited_theme_widget.dart';

class ExerciseTimerWidget extends StatefulWidget {
  const ExerciseTimerWidget({Key? key,
    required this.controller,
  }) : super(key: key);

  final ExerciseTimerController controller;

  @override
  State<ExerciseTimerWidget> createState() => _ExerciseTimerWidgetState();
}

class _ExerciseTimerWidgetState extends State<ExerciseTimerWidget> {

  int timeLeft = 0;
  int totalTime = 0;

  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {
        timeLeft = widget.controller.timeLeft.toInt();
        totalTime = widget.controller.totalTime.toInt();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return timeLeft != 0 ?
    Expanded(
      child: ClipRRect(
        borderRadius: BorderRadiusDirectional.circular(8),
        child: SizedBox(
          height: 38,
          child: Stack(
            children: [
              LinearProgressIndicator(
                backgroundColor: T(context).color.secondary,
                color: T(context).color.primary,
                value: timeLeft / totalTime,
                minHeight: 38,
              ),
              Center(
                child: Text(
                  secondsToTime(timeLeft),
                  style: TextStyle(
                    color: timeLeft / totalTime > 0.5 ? T(context).color.neutral : T(context).color.primary,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              MButton(
                onPressed: () async {
                },
                expand: false,
                backgroundColor: Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    )
        :
    MButton(
      onPressed: () async {
        showBottomSheetDialog(
          context: context,
          child: TimedPickerDialog(
            initialValue: Timed.zero(),
            onSubmit: (value) {
              widget.controller.startTimer(value);
            },
          ),
          onClose: (){},
        );
      },
      child: Icon(
        Icons.timer,
        size: 21,
        color: T(context).color.onSurface,
      ),
      height: 38,
      width: 38,
      backgroundColor: T(context).color.surface,
    );
  }
}

class ExerciseTimerController extends ChangeNotifier {
  ExerciseTimerController();

  Timer? timer;
  int timeLeft = 0;
  int totalTime = 0;

  void startTimer(Timed timed) {
    if(timer != null) {
      timer!.cancel();
    }
    timeLeft = timed.toSeconds();
    totalTime = timed.toSeconds();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (timeLeft == 0) {
        timer!.cancel();
        notifyListeners();
      } else {
        timeLeft--;
        notifyListeners();
      }
    });
  }

  void stop() {
    timer?.cancel();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
