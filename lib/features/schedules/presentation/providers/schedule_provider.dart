import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/service_locator.dart';
import '../../data/models/schedule_class.dart';
import '../../domain/repositories/schedule_repository.dart';

final scheduleRepositoryProvider = Provider<ScheduleRepository>(
  (ref) => serviceLocator<ScheduleRepository>(),
);

final scheduleProvider = StreamProvider<List<ScheduleClass>>(
  (ref) => ref.watch(scheduleRepositoryProvider).watchSchedule(),
);
