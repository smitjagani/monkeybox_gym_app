part of 'workout_bloc.dart';

abstract class WorkoutState extends Equatable {
  const WorkoutState();

  @override
  List<Object> get props => [];
}

class WorkoutInitial extends WorkoutState {
  const WorkoutInitial();
  @override
  List<Object> get props => [];
}

class DisplayAllDatas extends WorkoutState {
  final List<Workout> workouts;
  const DisplayAllDatas({required this.workouts});

  @override
  List<Object> get props => [workouts];
}
