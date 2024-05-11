import 'package:hive/hive.dart';
import 'model/workout.dart';

class Boxes {
  static Box<Workout> getTransactions() => Hive.box<Workout>('workout');
}
