import 'package:hive/hive.dart';
import 'package:monkeybox_fitness_task/model/excercise.dart';
part 'workout.g.dart';

@HiveType(typeId: 0)
class Workout extends HiveObject {
  @HiveField(0)
  late String workoutName;
  @HiveField(1)
  late List<Excercise> excerciseData;
}
