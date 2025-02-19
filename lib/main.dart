
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:maven/feature/exercise/service/shared_preferences_service.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maven/feature/ml_model/calorie_storage_service.dart';
import 'package:maven/feature/ml_model/calorie_manager.dart';

import 'database/database.dart';
import 'debug/screen/design_tool_widget.dart';
import 'feature/app/screen/app_screen.dart';
import 'feature/equipment/equipment.dart';
import 'feature/exercise/exercise.dart';
import 'feature/routine/service/service.dart';
import 'feature/session/session.dart';
import 'feature/settings/settings.dart';
import 'feature/template/template.dart';
import 'feature/theme/theme.dart';
import 'feature/transfer/transfer.dart';
import 'feature/user/user.dart';
import 'feature/user/screen/user_setup_screen.dart'; 
import 'feature/workout/workout.dart';
import 'generated/l10n.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  
  final TritiumDatabase db = await TritiumDatabase.initialize();
  final prefs = await SharedPreferences.getInstance();
  
  // Initialize CalorieStorage and Manager
  final calorieStorage = CalorieStorageService(prefs);
  final calorieManager = CalorieManager(calorieStorage);

  runApp(
    
    MultiProvider(
      providers: [
        // Providing DAOs at the root level so they are available throughout the app
        Provider<CalorieManager>(create: (_) => calorieManager),
        Provider<RoutineDao>(create: (_) => db.routineDao),
        Provider<TemplateDataDao>(create: (_) => db.templateDataDao),
        Provider<ExerciseDao>(create: (_) => db.exerciseDao),
        Provider<SessionDataDao>(create: (_) => db.sessionDataDao),
        
        // Add other DAOs as needed
      ],
      child: Main(db: db),
    ),
  );
}

class Main extends StatelessWidget {
  const Main({
    super.key,
    required this.db,
  });

  final TritiumDatabase db;

  @override
  Widget build(BuildContext context) {
    DatabaseService databaseService = DatabaseService(
      exerciseDao: db.exerciseDao,
      settingDao: db.settingsDao,
      exerciseGroupDao: db.baseExerciseGroupDao,
      exerciseSetDao: db.exerciseSetDao,
      exerciseSetDataDao: db.exerciseSetDataDao,
      noteDao: db.noteDao,
      userDao: db.userDao,
    );

    ExerciseService exerciseService = ExerciseService(
      exerciseDao: db.exerciseDao,
      exerciseFieldDao: db.exerciseFieldDao,
    );
    TransferService strongService = TransferService(
      exercises: getDefaultExercises(),
      importDao: db.importDao,
      exportDao: db.exportDao,
    );
    EquipmentService equipmentService = EquipmentService(
      plateDao: db.plateDao,
      barDao: db.barDao,
    );
    SettingsService settingsService = SettingsService(
      settingsDao: db.settingsDao,
      themeDao: db.themeDao,
      themeColorDao: db.themeColorDao,
    );
    RoutineService routineService = RoutineService(
      routineDao: db.routineDao,
      exerciseGroupDao: db.baseExerciseGroupDao,
      noteDao: db.noteDao,
      exerciseSetDao: db.exerciseSetDao,
      exerciseSetDataDao: db.exerciseSetDataDao,
      workoutDataDao: db.workoutDataDao,
      exerciseDao: db.exerciseDao,
      templateDataDao: db.templateDataDao,
      sessionDataDao: db.sessionDataDao,
      calorieManager: context.read<CalorieManager>(), 
    );

    return MultiBlocProvider(
      providers: [
        
        BlocProvider(
            create: (context) => ExerciseBloc(
                  exerciseService: exerciseService,
                )..add(const ExerciseInitialize())),
        BlocProvider(
            create: (context) => TemplateBloc(
                  databaseService: databaseService,
                  routineService: routineService,
                )..add(const TemplateInitialize())),
        BlocProvider(
            create: (context) => ThemeBloc(
                  themeDao: db.themeDao,
                  themeColorDao: db.themeColorDao,
                  settingDao: db.settingsDao,
                )..add(const ThemeInitialize())),
        BlocProvider(
            create: (context) => WorkoutBloc(
                  databaseService: databaseService,
                  routineService: routineService,
                  calorieManager: context.read<CalorieManager>(), 
                  sharedPreferencesService: SharedPreferencesService(),
                  
                  
                  
                )..add(const WorkoutInitialize())),
        BlocProvider(
            create: (context) => EquipmentBloc(
                  equipmentService: equipmentService,
                )..add(const EquipmentInitialize())),
        BlocProvider(
            create: (context) => SessionBloc(
                  databaseService: databaseService,
                  routineService: routineService,
                  
                  calorieManager: context.read<CalorieManager>(), 
                )..add(const SessionInitialize())),
        BlocProvider(
            create: (context) => SettingsBloc(
                  settingsService: settingsService,
                )..add(const SettingsInitialize())),
        BlocProvider(
            create: (context) => UserBloc(
                  userDao: db.userDao,
                  database : db,
                )..add(const UserInitialize())),
        BlocProvider(
            create: (context) => TransferBloc(
                  transferService: strongService,
                  routineService: routineService,
                )..add(const TransferInitialize())),
      ],
      child: FutureBuilder<bool>(
        future: db.userDao.isFirstLaunch(), // Check if first launch
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final isFirstLaunch = snapshot.data ?? true;

          return BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              if (state.status.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state.status.isLoaded) {
                return SettingsProvider(
                  settings: state.settings!,
                  child: ThemeProvider(
                    useSystemTheme: state.settings!.useSystemDefaultTheme,
                    child: Builder(
                      builder: (context) {
                        return DynamicColorBuilder(
                          builder: (lightDynamic, darkDynamic) {
                            return MaterialApp(
                               debugShowCheckedModeBanner: false,
                              theme: InheritedThemeWidget.of(context).theme.data,
                              title: 'Maven',
                              localizationsDelegates: const [
                                S.delegate,
                                GlobalMaterialLocalizations.delegate,
                                GlobalWidgetsLocalizations.delegate,
                                GlobalCupertinoLocalizations.delegate,
                              ],
                              locale: state.settings!.locale,
                              supportedLocales: S.delegate.supportedLocales,
                              home: isFirstLaunch
                                  ? UserSetupScreen() // First-time setup screen
                                  : const Stack(
                                      children: [
                                        Maven(),
                                        Visibility(
                                          visible: kDebugMode,
                                          child: DesignToolWidget(),
                                        ),
                                      ],
                                    ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        },
      ),
    );
  }
}

class CustomScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}
