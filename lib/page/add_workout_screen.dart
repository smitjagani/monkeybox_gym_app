import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeybox_fitness_task/bloc/workout_bloc.dart';
import 'package:monkeybox_fitness_task/model/excercise.dart';
import 'package:monkeybox_fitness_task/model/workout.dart';
import 'package:monkeybox_fitness_task/widgets/commom_textfield.dart';

class AddWorkOutScreen extends StatefulWidget {
  final Workout workoutData;
  final bool isEdit;
  final int editIndex;

  const AddWorkOutScreen(
      {super.key, required this.workoutData, required this.isEdit, required this.editIndex});

  @override
  State<AddWorkOutScreen> createState() => _AddWorkOutScreenState();
}

class _AddWorkOutScreenState extends State<AddWorkOutScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  List<Excercise> exerciseList = [];
  final ValueNotifier<List<Excercise>> selectedItemsNotifier = ValueNotifier<List<Excercise>>([]);

  @override
  void initState() {
    loadExerciseData();
    titleController.text = widget.isEdit ? widget.workoutData.workoutName : "";
    selectedItemsNotifier.value = widget.isEdit ? widget.workoutData.excerciseData : [];
    super.initState();
  }

  Future<void> loadExerciseData() async {
    try {
      var jsonString = await rootBundle.loadString(
        'assets/exercise.json',
      );
      setState(() {
        if (jsonString.isNotEmpty) {
          for (var e in jsonDecode(jsonString)['entity']['data']) {
            exerciseList.add(Excercise.fromJson(e));
          }
        }
      });
    } catch (e) {
      log('Error loading JSON: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        title: Text(
          widget.isEdit ? "Edit Workout" : "Add Workout",
          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonTextFormField(
                key: const ValueKey("first"),
                controller: titleController,
                hineText: "Enter Title",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter workout title';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              ValueListenableBuilder(
                  valueListenable: selectedItemsNotifier,
                  builder: (c, items, _) {
                    return Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (context, exerciseIndex) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(items[exerciseIndex].name),
                              ),
                            );
                          }),
                    );
                  }),
              GestureDetector(
                onTap: () {
                  _showBottomSheet(context, selectedItemsNotifier);
                },
                child: Container(
                  key: const ValueKey('exercise'),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xffEDF3FF),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    border: Border.all(color: const Color(0xffCBCACA)),
                  ),
                  child: const Center(
                      child: Text(
                    "Add Exercise",
                    style: TextStyle(
                        color: Color(0xff1E346F), fontSize: 16, fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    if (!widget.isEdit) {
                      context.read<WorkoutBloc>().add(
                            AddData(
                                workout: Workout()
                                  ..workoutName = titleController.text
                                  ..excerciseData = selectedItemsNotifier.value),
                          );
                    } else {
                      context.read<WorkoutBloc>().add(
                            UpdateSpecificData(
                                name: titleController.text,
                                exercise: selectedItemsNotifier.value,
                                workout: widget.workoutData,
                                index: widget.editIndex),
                          );

                    }
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  key: const ValueKey('btn'),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12), color: const Color(0xff1E346F)),
                  child: Center(
                      child: Text(
                    widget.isEdit ? "UPDATE" : "ADD",
                    style: const TextStyle(
                        color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _showBottomSheet(BuildContext context, ValueNotifier<List<Excercise>> selectedItemsNotifier) {
    List<Excercise> filterList = exerciseList;

    TextEditingController searchController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(builder: (context, setData) {
          return GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              color: const Color.fromRGBO(0, 0, 0, 0.001),
              child: GestureDetector(
                onTap: () {},
                child: DraggableScrollableSheet(
                  initialChildSize: 0.7,
                  minChildSize: 0.2,
                  maxChildSize: 0.75,
                  builder: (_, controller) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.remove,
                              color: Colors.grey[600],
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: CommonTextFormField(
                                  hineText: "search",
                                  controller: searchController,
                                  onChanged: (v) {
                                    searchController.text = v;
                                    filterList = exerciseList
                                        .where((element) =>
                                            element.name.toLowerCase().contains(v.toLowerCase()))
                                        .toList();
                                    setData(() {});
                                    log(filterList.length.toString());
                                  },
                                )),
                              ],
                            ),
                            Expanded(
                              child: ListView.builder(
                                controller: controller,
                                itemCount: filterList.length,
                                itemBuilder: (_, index) {
                                  return Card(
                                    child: ListTile(
                                      title: Text(filterList[index].name),
                                      trailing: Checkbox(
                                          activeColor: const Color(0xff1E346F),
                                          value: selectedItemsNotifier.value.isNotEmpty &&
                                                  selectedItemsNotifier.value
                                                      .any((e) => e.id == filterList[index].id)
                                              ? true
                                              : false,
                                          onChanged: (v) {
                                            if (selectedItemsNotifier.value
                                                .any((e) => e.id == filterList[index].id)) {
                                              selectedItemsNotifier.value.removeWhere(
                                                  (element) => element.id == filterList[index].id);
                                            } else {
                                              selectedItemsNotifier.value.add(filterList[index]);
                                            }
                                            selectedItemsNotifier.notifyListeners();
                                            setData(() {});
                                            log(selectedItemsNotifier.value
                                                .map((e) => e.name)
                                                .toList()
                                                .toString());
                                          }),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
