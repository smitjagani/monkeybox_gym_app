import 'package:hive_flutter/hive_flutter.dart';
import 'package:monkeybox_fitness_task/model/excercise.dart';
import 'package:monkeybox_fitness_task/model/workout.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(WorkoutAdapter());
  Hive.registerAdapter(ExcerciseAdapter());
  Hive.registerAdapter(EquipmentAdapter());
  Hive.registerAdapter(MuscleAdapter());
  Hive.registerAdapter(CategoryAdapter());
  await Hive.openBox<Workout>('workout');
}
