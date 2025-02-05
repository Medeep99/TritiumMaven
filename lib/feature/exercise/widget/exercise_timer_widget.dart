import 'dart:async';

import 'package:flutter/material.dart';

import '../../../common/common.dart';
import '../../theme/theme.dart';

class ExerciseTimerWidget extends StatefulWidget {
  const ExerciseTimerWidget({
    Key? key,
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
  void _updateTimer() {
    if (mounted) {  // Ensure the widget is still in the tree
      setState(() {
        timeLeft = widget.controller.timeLeft;
        totalTime = widget.controller.totalTime;
      });
    }
  }
  @override
  void dispose() {
    // widget.controller.removeListener(() {});
    widget.controller.removeListener(_updateTimer);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (timeLeft != 0) {
      return Expanded(
        child: ClipRRect(
          borderRadius: BorderRadiusDirectional.circular(T(context).shape.large),
          child: SizedBox(
            height: 40,
            child: Stack(
              children: [
                LinearProgressIndicator(
                  backgroundColor: T(context).color.surface,
                  color: T(context).color.primary,
                  value: timeLeft / totalTime,
                  minHeight: 38,
                ),
                Center(
                  child: Text(
                    secondsToTime(timeLeft),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                MButton(
                  onPressed: () async {},
                  expand: false,
                  backgroundColor: Colors.transparent,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return MButton(
        onPressed: () async {
          showBottomSheetDialog(
            context: context,
            child: TimedPickerDialog(
              initialValue: Timed.zero(),
              onSubmit: (value) {
                widget.controller.startTimer(value);
              },
            ),
            onClose: () {},
          );
        },
        height: 38,
        width: 38,
        backgroundColor: T(context).color.surface,
        child: Icon(
          Icons.timer,
          size: 21,
          color: T(context).color.onSurface,
        ),
      );
    }
  }
}

class ExerciseTimerController extends ChangeNotifier {
  ExerciseTimerController();

  Timer? timer;
  int timeLeft = 0;
  int totalTime = 0;

  void startTimer(Timed timed) {
    if (timer != null) {
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

  // void stop() {
  //   timer?.cancel();
  // }
 void stop() {
  if (timer != null) {
    timer!.cancel();
    timer = null;
  }
  timeLeft = 0;
  totalTime = 0;
  notifyListeners(); // Ensure UI updates after stopping
}

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
