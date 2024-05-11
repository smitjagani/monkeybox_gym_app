part of 'workout_bloc.dart';

abstract class WorkoutEvent extends Equatable {
  const WorkoutEvent();

  @override
  List<Object> get props => [];
}

class FetchAllData extends WorkoutEvent {
  const FetchAllData();

  @override
  List<Object> get props => [];
}

class FetchSpecificData extends WorkoutEvent {
  const FetchSpecificData();

  @override
  List<Object> get props => [];
}

class AddData extends WorkoutEvent {
  final Workout workout;

  const AddData({required this.workout});

  @override
  List<Object> get props => [workout];
}

class DeleteSpecificData extends WorkoutEvent {
  final Workout workout;

  const DeleteSpecificData({required this.workout});

  @override
  List<Object> get props => [workout];
}

class UpdateSpecificData extends WorkoutEvent {
  final int index;
  final String name;
  final List<Excercise> exercise;
  final Workout workout;

  const UpdateSpecificData({required this.name,
    required this.exercise,
    required this.workout,
    required this.index});

  @override
  List<Object> get props => [name, exercise, workout, index];

}
