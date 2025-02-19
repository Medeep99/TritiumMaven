
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maven/common/widget/calorie_line_chart.dart';
import 'package:maven/feature/ml_model/calorie_manager.dart';
import 'package:maven/feature/ml_model/calorie_record.dart';
import 'package:maven/feature/ml_model/calorie_storage_service.dart';
import 'package:maven/feature/session/widget/session_weekly_goal_widget.dart';
import 'package:maven/feature/user/services/shared_preferences_data.dart';// Import the new widget
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

import '../../../common/common.dart';
import '../../../database/database.dart';
import '../../session/session.dart';
import '../../settings/settings.dart';
import '../../theme/theme.dart';
import '../../user/user.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key,
  }) : super(key: key);
  

  
  @override
  Widget build(BuildContext context) {
    return TitledScaffold(
      title: 'Home',
      slivers: [
        const Heading(
          title: 'Dashboard',
          size: HeadingSize.small,
        ),
        BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state.status.isLoading) {
              return const SliverBoxWidget(
                type: SliverBoxType.loading,
              );
            } else if (state.status.isLoaded) {
              return SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    decoration: BoxDecoration(
                      color: T(context).color.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.all(T(context).space.large),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('MMMMEEEEd').format(DateTime.now()),
                          style: T(context).textStyle.labelSmall.copyWith(
                            color: T(context).color.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          'Good ${greeting()}',
                          style: T(context).textStyle.headingMedium,
                        ),
                      ],
                    ),
                  ),
                ]),
              );
            } else {
              return Center(
                child: Text(
                  'Error',
                  style: T(context).textStyle.bodyLarge,
                ),
              );
            }
          },
        ),
        Heading(
          title: 'Overview',
        ),
        BlocBuilder<SessionBloc, SessionState>(
          builder: (context, state) {
            if (state.status.isLoading) {
              return const SliverBoxWidget(
                type: SliverBoxType.loading,
              );
            } else if (state.status.isLoaded) {
              return SliverList(
                delegate: SliverChildListDelegate([
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: 100,
                          padding: EdgeInsets.all(T(context).space.large),
                          decoration: BoxDecoration(
                            color: T(context).color.surface,
                            borderRadius: BorderRadius.circular(T(context).shape.large),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.local_fire_department_rounded,
                                color: Colors.orange,
                                size: 32,
                              ),
                              SizedBox(width: T(context).space.large),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DatabaseService.getWeekStreak(state.sessions.map((e) => e.routine.timestamp).toList()).toString(),
                                    style: T(context).textStyle.headingMedium,
                                  ),
                                  const Text('Week Streak'),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: T(context).space.medium),
                      Expanded(
                        child: Container(
                          height: 100,
                          padding: EdgeInsets.all(T(context).space.large),
                          decoration: BoxDecoration(
                            color: T(context).color.surface,
                            borderRadius: BorderRadius.circular(T(context).shape.large),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Total Workouts'),
                              Text(
                                '${state.sessions.length}',
                                style: T(context).textStyle.headingMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: T(context).space.medium),
                  FutureBuilder<int?>(
                    future: GlobalSettings.getGoal(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasData && snapshot.data != null) {
                        final goal = snapshot.data!;
                        return SessionWeeklyGoalWidget(
                          goal: goal,
                          onModified: (value) {
                            GlobalSettings.setGoal(value); // Update global goal
                            context.read<SettingsBloc>().add(
                              SettingsUpdate(
                                InheritedSettingsWidget.of(context).settings.copyWith(
                                  sessionWeeklyGoal: value,
                                ),
                              ),
                            );
                          },
                          dates: state.sessions.map((e) => e.routine.timestamp).toList(),
                        );
                      }
                      return Center(child: Text('No goal set'));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,0,10.0),
                    child: SizedBox(height: T(context).space.medium),
                  ),
                  // Add the CalorieBurntLineChart here
                  FutureBuilder<SharedPreferences>(
                    future: SharedPreferences.getInstance(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasData) {
                        final prefs = snapshot.data!;
                        final calorieManager = CalorieManager(CalorieStorageService(prefs));
                        
                        return FutureBuilder<List<CalorieRecord>>(
                          
                          future: Future.value(calorieManager.getCalorieHistory()),
                          
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                              return CalorieBurntLineChart(calorieHistory: snapshot.data!);
                            }
                            return Center(
                              child: Text(
                                'No calorie data available',
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          },
                        );
                        
                      }
                      return Center(
                        child: Text(
                          'Failed to load SharedPreferences',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ]),
              );
            } else {
              return const SliverBoxWidget(
                type: SliverBoxType.empty,
              );
            }
          },
        ),
      ],
    );
  }
}