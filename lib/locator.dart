import 'package:get_it/get_it.dart';
import 'package:my_zero_broker/data/user_id.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton(UserId()); 
}
