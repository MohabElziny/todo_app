abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppChangeButtonNavBarState extends AppStates {} // then goto cubit.dart

class AppCreateDataBaseState extends AppStates {}
class AppInsertDataBaseState extends AppStates {}
class AppGetDataBaseState extends AppStates {}
class AppUpdateDataBaseState extends AppStates {}
class AppGetDataBaseLoadingState extends AppStates {}
class AppDeleteFromDataBase extends AppStates {}

class AppChangeBottomSheetState extends AppStates {}