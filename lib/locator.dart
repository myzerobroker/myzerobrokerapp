import 'package:get_it/get_it.dart';
import 'package:my_zero_broker/data/area_details_dependency.dart';
import 'package:my_zero_broker/data/user_id.dart';
import 'package:my_zero_broker/presentation/screens/post_property/post_property_depenency.dart/dependency_class.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton(UserId());
  locator.registerSingleton(PostPropertyDependency()); 
  locator.registerSingleton(AreaDetailsDependency());
}
