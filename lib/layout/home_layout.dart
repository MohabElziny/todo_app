
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';


class HomeLayout extends StatelessWidget
{

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(), // (..) like u save in variable
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDataBaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {

          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                // titles[currentIndex],
                cubit.titles[cubit.currentIndex],
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDataBaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.isBottomSheetShown){
                    if (formKey.currentState.validate()){
                      cubit.insertToDataBase(
                          title: titleController.text,
                          time: timeController.text,
                          date: dateController.text
                      );
                    }
                  }
                  else {
                    scaffoldKey.currentState.showBottomSheet((context) =>
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormField(
                                  controller:  titleController,
                                  type: TextInputType.text,
                                  validate: (String value){
                                    if(value.isEmpty){
                                      return 'Title must not be empty';
                                    }
                                    return null;
                                  },
                                  label: 'Task Title',
                                  prefix: Icons.title,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                defaultFormField(
                                  controller:  timeController,
                                  type: TextInputType.datetime,
                                  onTap: (){
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timeController.text = value.format(context).toString();
                                    });
                                  },
                                  validate: (String value){
                                    if(value.isEmpty){
                                      return 'Time must not be empty';
                                    }
                                    return null;
                                  },
                                  label: 'Task Time',
                                  prefix: Icons.watch_later_outlined,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                defaultFormField(
                                  controller:  dateController,
                                  type: TextInputType.datetime,
                                  onTap: (){
                                    showDatePicker(
                                      firstDate:DateTime.now(),
                                      lastDate: DateTime(2050),
                                      context: context,
                                      initialDate: DateTime.now(),
                                    ).then((value) {
                                      dateController.text = DateFormat.yMMMd().format(value);
                                    });
                                  },
                                  validate: (String value){
                                    if(value.isEmpty){
                                      return 'Date must not be empty';
                                    }
                                    return null;
                                  },
                                  label: 'Task Date',
                                  prefix: Icons.calendar_today,
                                ),
                              ],
                            ),
                          ),
                        ),
                      elevation: 20.0,
                    )
                        .closed
                        .then((value)
                    {
                      cubit.changeBottomSheetState(
                        isShow: false,
                        icon: Icons.edit,
                      );
                    });

                    cubit.changeBottomSheetState(
                      isShow: true,
                      icon: Icons.add,
                    );
                  }
                },
                child: Icon(
                  cubit.fabIcon,
                )

            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              // currentIndex: currentIndex,
              currentIndex: cubit.currentIndex,
              onTap: (index){
                cubit.changeIndex(index);
                // setState(() {
                //   currentIndex = index;
                // });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archive',
                ),
              ],
            ),
          );
        },
      ),
    );
  }


}


