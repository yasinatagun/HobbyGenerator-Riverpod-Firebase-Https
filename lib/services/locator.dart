import 'package:get_it/get_it.dart';
import 'package:hobby_generator/services/sp_service.dart';
import 'package:hobby_generator/services/user_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
 
  locator.registerLazySingleton<SharedPreferencesService>(
      () => SharedPreferencesService());
  locator.registerLazySingleton<UserManager>(() => UserManager());

}
