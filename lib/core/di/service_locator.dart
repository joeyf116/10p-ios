import 'package:get_it/get_it.dart';

final GetIt serviceLocator = GetIt.instance;

void configureDependencies() {
  if (!serviceLocator.isRegistered<DateTime>()) {
    serviceLocator.registerFactory<DateTime>(DateTime.now);
  }
}
