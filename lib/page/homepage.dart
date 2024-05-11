import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeybox_fitness_task/bloc/workout_bloc.dart';
import 'package:monkeybox_fitness_task/page/add_workout_screen.dart';
import '../model/workout.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff1E346F),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddWorkOutScreen(
                        isEdit: false,
                        workoutData: Workout(),
                        editIndex: 0,
                      )));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Workout Management',
        ),
      ),
      body: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutInitial) {
            context.read<WorkoutBloc>().add(const FetchAllData());
          }
          if (state is DisplayAllDatas) {
            if (state.workouts.isNotEmpty) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.all(8),
                      itemCount: state.workouts.length,
                      itemBuilder: (context, i) {
                        log(state.workouts[i].workoutName);
                        return Container(
                          padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          decoration: BoxDecoration(
                              border: const Border(
                                left: BorderSide(width: 5.0, color: Color(0xff1E346F)),
                              ),
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xffEDF3FF)),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                color: const Color(0xff1E346F),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.grey.shade300,
                                child: Text(
                                  state.workouts[i].workoutName[0].toUpperCase(),
                                  style: const TextStyle(
                                      color: Color(0xff1E346F),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.workouts[i].workoutName.toString().toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddWorkOutScreen(
                                              isEdit: true,
                                              workoutData: state.workouts[i],
                                              editIndex: i))).whenComplete(() => setState(() {}));
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey.shade300,
                                  radius: 15,
                                  child: const Icon(
                                    Icons.edit,
                                    color: Color(0xff1E346F),
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Are you sure you want to delete?',
                                          style: TextStyle(
                                              color: Color(0xff1E346F),
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      contentPadding:
                                          const EdgeInsets.symmetric(vertical: 5, horizontal: 24),
                                      content: const Text(
                                          'This action will permanently delete this data',
                                          style: TextStyle(
                                            fontSize: 14,
                                          )),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: const Text('Cancel',
                                              style: TextStyle(
                                                  color: Color(0xff1E346F),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            context.read<WorkoutBloc>().add(
                                                DeleteSpecificData(workout: state.workouts[i]));
                                            Navigator.pop(context, true);
                                          },
                                          child: const Text('Delete',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey.shade300,
                                  radius: 15,
                                  child: const Icon(
                                    Icons.delete_rounded,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          }
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Please add a workout by\ntapping on below + button",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xff1E346F), fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}
