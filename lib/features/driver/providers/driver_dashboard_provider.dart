import 'package:flutter/foundation.dart';

import '../../../core/state/view_state.dart';
import '../data/driver_repository.dart';
import '../models/driver_dashboard_models.dart';

class DriverDashboardProvider extends ChangeNotifier with ViewStateMixin {
  DriverDashboardProvider({required DriverRepository repository})
    : _repository = repository;

  final DriverRepository _repository;

  DriverDashboardStatsModel _stats = const DriverDashboardStatsModel.empty();
  NextTripSummaryModel? _nextTrip;

  DriverDashboardStatsModel get stats => _stats;
  NextTripSummaryModel? get nextTrip => _nextTrip;
  bool get hasNextTrip => _nextTrip != null;

  Future<void> load() async {
    setLoading();
    try {
      final results = await Future.wait([
        _repository.fetchDashboardStats(),
        _repository.fetchNextTrip(),
      ]);

      _stats = results[0] as DriverDashboardStatsModel;
      _nextTrip = results[1] as NextTripSummaryModel?;
      setSuccess();
    } catch (error) {
      setError('Could not load your dashboard. Please try again.');
    }
  }

  Future<void> refresh() async {
    try {
      final results = await Future.wait([
        _repository.fetchDashboardStats(),
        _repository.fetchNextTrip(),
      ]);

      _stats = results[0] as DriverDashboardStatsModel;
      _nextTrip = results[1] as NextTripSummaryModel?;
      setSuccess();
    } catch (error) {
      setError('Could not refresh. Please try again.');
    }
  }
}
