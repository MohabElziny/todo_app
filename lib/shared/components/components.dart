import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget defaultFormField ({
  @required TextEditingController controller,
  @required TextInputType type,
  Function onSubmit,
  Function onChange,
  Function onTap,
  @required Function validate,
  @required String label,
  @required IconData prefix,
  bool isPassword = false,
  bool isClickable = true,
  IconData suffix,
  Function suffixPressed,

}) => TextFormField(
  controller: controller,
  keyboardType: type,
  onFieldSubmitted: onSubmit,
  onChanged: onChange,
  validator: validate,
  enabled: isClickable,
  onTap: onTap,
  obscureText: isPassword,
  decoration: InputDecoration(
    labelText: label,
    prefixIcon: Icon(
      prefix,
    ),
    suffixIcon: suffix != null ? IconButton(
      onPressed: suffixPressed,
      icon: Icon(
        suffix,
      ),

    ) : null,
    border: OutlineInputBorder(),
  ),
);

// ignore: non_constant_identifier_names
Widget buildTaskItem(Map model, context,{
    IconData doneButton,
    IconData archiveButton,
}) => Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
    children: [
      CircleAvatar(
        radius: 40,
        child: Text(
          '${model['time']}',
        ),
      ),
      SizedBox(
        width: 15,
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${model['title']}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              '${model['date']}',
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: 15,
      ),
      doneButton != null ? IconButton(
          icon: Icon(
            // Icons.check_box,
            doneButton,
            color: Colors.green[600],
          ),
          onPressed: (){
            AppCubit.get(context).updateData(status: 'done', id: model['id']);
          }
      ) : SizedBox(width: 0.1,),
      archiveButton != null ? IconButton(
          icon: Icon(
            archiveButton,
            color: Colors.black45,
          ),
          onPressed: (){
            AppCubit.get(context).updateData(status: 'archive', id: model['id']);
          }
      ) : SizedBox(width: 0.1,),
      IconButton(
          icon: Icon(
            Icons.delete_forever,
            color: Colors.red[600],
          ),
          onPressed: (){
            AppCubit.get(context).deleteData(id: model['id']);
          }
      ),
    ],
  ),
);

Widget tasksBuilder({
  @required List<Map> tasks,
  IconData doneButton2,
  IconData archiveButton2,
}) =>
    ConditionalBuilder(
      condition: tasks.length > 0,
      builder: (context) => ListView.separated(
      itemBuilder: (context, index) => buildTaskItem( tasks[index], context,
        doneButton: doneButton2,
        archiveButton: archiveButton2,
      ),
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsetsDirectional.only(
          start: 20,
        ),
        child: Container(
          width: double.infinity,
          height: 1,
          color: Colors.grey[300],
        ),
      ),
        itemCount: tasks.length,
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 100.0,
              color: Colors.grey,
            ),
            Text(
              'No Tasks Yet, Please Add Some Tasks',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );