import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:monkeybox_fitness_task/model/excercise.dart';
import 'package:monkeybox_fitness_task/model/workout.dart';

import '../../boxes.dart';

part 'workout_event.dart';
part 'workout_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  WorkoutBloc() : super(const WorkoutInitial()) {
    Box<Workout> boxWorkout;
    List<Workout> workoutList = [];
    Workout workout;
    on<FetchAllData>((event, emit) {
      try {
        boxWorkout = Boxes.getTransactions();
        workoutList = boxWorkout.values.toList();
        emit(DisplayAllDatas(workouts: workoutList));
      } catch (e) {
        debugPrint('$e');
      }
    });

    on<AddData>((event, emit) {
      try {
        final box = Boxes.getTransactions();
        box.add(event.workout);
        add(const FetchAllData());
      } catch (e) {
        debugPrint('$e');
      }
    });

    on<UpdateSpecificData>((event, emit) {
      try {
        final box = Boxes.getTransactions();
        workout = event.workout;
        workout.workoutName = event.name;
        workout.excerciseData = event.exercise;
        workoutList[event.index] = workout;
        workoutList[event.index].save();
        box.putAt(event.index, workout);
        add(const FetchAllData());
      } catch (e) {
        debugPrint('$e');
      }
    });

    on<DeleteSpecificData>((event, emit) {
      try {
        final box = Boxes.getTransactions();
        box.delete(event);
        event.workout.delete();
        add(const FetchAllData());
      } catch (e) {
        debugPrint('$e');
      }
    });
  }
}
