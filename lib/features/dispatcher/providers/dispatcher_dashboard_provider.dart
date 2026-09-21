import 'package:flutter/foundation.dart';

import '../../../core/state/view_state.dart';
import '../data/dispatcher_repository.dart';
import '../models/dispatcher_stats_model.dart';
import '../models/reservation_request_model.dart';

/// Owns everything the Dispatcher Dashboard renders.
///
/// The provider depends on the *abstract* repository, never on the mock, so
/// the swap to a real API is invisible from here.
class DispatcherDashboardProvider extends ChangeNotifier with ViewStateMixin {
  DispatcherDashboardProvider({required DispatcherRepository repository})
    : _repository = repository;

  final DispatcherRepository _repository;

  /// How many rows the dashboard preview shows before "View all pending queue".
  static const int previewLimit = 4;

  DispatcherStatsModel _stats = const DispatcherStatsModel.empty();
  List<ReservationRequestModel> _pendingRequests = const [];

  /// IDs currently being approved/rejected — lets one row show a spinner
  /// without blocking the whole table.
  final Set<String> _busyRequestIds = {};

  DispatcherStatsModel get stats => _stats;
  List<ReservationRequestModel> get pendingRequests =>
      List.unmodifiable(_pendingRequests);
  bool get hasRequests => _pendingRequests.isNotEmpty;

  bool isRequestBusy(String id) => _busyRequestIds.contains(id);

  Future<void> load() async {
    setLoading();
    try {
      final results = await Future.wait([
        _repository.fetchStats(),
        _repository.fetchPendingRequests(limit: previewLimit),
      ]);

      _stats = results[0] as DispatcherStatsModel;
      _pendingRequests = results[1] as List<ReservationRequestModel>;
      setSuccess();
    } catch (error) {
      setError('Could not load the dispatcher dashboard. Please try again.');
    }
  }

  /// Pull-to-refresh and the post-review refetch. Unlike [load] this keeps the
  /// current content on screen instead of flashing a spinner.
  Future<void> refresh() async {
    try {
      final results = await Future.wait([
        _repository.fetchStats(),
        _repository.fetchPendingRequests(limit: previewLimit),
      ]);

      _stats = results[0] as DispatcherStatsModel;
      _pendingRequests = results[1] as List<ReservationRequestModel>;
      setSuccess();
    } catch (error) {
      setError('Could not refresh. Please try again.');
    }
  }

  /// Returns `true` on success so the screen can decide whether to show a
  /// snackbar. Errors are surfaced, not swallowed.
  Future<bool> reviewRequest({
    required String requestId,
    required RequestStatus decision,
    String? rejectionReason,
  }) async {
    if (_busyRequestIds.contains(requestId)) return false;

    _busyRequestIds.add(requestId);
    notifyListeners();

    try {
      await _repository.updateRequestStatus(
        requestId: requestId,
        status: decision,
        rejectionReason: rejectionReason,
      );

      // Drop the row optimistically, then resync the counters.
      _pendingRequests = _pendingRequests
          .where((request) => request.id != requestId)
          .toList();

      await refresh();
      return true;
    } catch (error) {
      setError('Could not update $requestId. Please try again.');
      return false;
    } finally {
      _busyRequestIds.remove(requestId);
      notifyListeners();
    }
  }
}
