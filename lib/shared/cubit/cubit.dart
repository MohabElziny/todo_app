
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super (AppInitialState());
  // object mn AppCubit
  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex =0;

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex (int index){
    currentIndex = index;
    emit(AppChangeButtonNavBarState());
  }

  Database db;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  // b emit fel .then
  void createDataBase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        print('database created');
        db.execute('CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)').then((value) {
          print('Table created');
        }).catchError((error){
          print('Error when creating table ${error.toString()}');
        });
      },
      onOpen: (db) {
        getDataFromDataBase(db);
        print('database opened');
      },
    ).then((value) {
      db = value;
      emit(AppCreateDataBaseState());
    });
  }

  insertToDataBase({
    @required String title,
    @required String time,
    @required String date,
  }) async
  {
    await db.transaction((txn){
      txn.rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "New")'
      ).then((value){
        print('$value inserted successfully');
        emit(AppInsertDataBaseState());

        getDataFromDataBase(db);

      }).catchError((error){
        print('Error when inserting new record ${error.toString()}');
      });
      return null;
    });
  }

  void getDataFromDataBase(db) {
    // w ana bbd2 dayman asafr
    newTasks =[];
    doneTasks =[];
    archiveTasks =[];
    emit(AppGetDataBaseLoadingState());
    db.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if(element['status'] == 'New'){
          newTasks.add(element);
        }
        else if(element['status'] == 'done'){
          doneTasks.add(element);
        }
        else archiveTasks.add(element);
        });
      emit(AppGetDataBaseState());
      print(value);
    }).catchError((error){
      print('Error when getting data from DataBase ${error.toString()}');
    });

  }

  void updateData({
    @required String status,
    @required int id,
  }) async
  {
    db.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value)
    {
      getDataFromDataBase(db);
      emit(AppUpdateDataBaseState());
    });
  } // tasks ta3od 3la table name

  void deleteData({
    @required int id,
  }) async
  {
    db.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value)
    {
      getDataFromDataBase(db);
      emit(AppDeleteFromDataBase());
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState ({
    @required bool isShow,
    @required IconData icon,
  })
  {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

}