import 'package:flutter/foundation.dart';

import '../../../core/state/view_state.dart';
import '../../dispatcher/models/reservation_request_model.dart';
import '../data/admin_repository.dart';
import '../models/fleet_vehicle_model.dart';

/// Backs the Vehicle Assignment screen: the reservation being assigned, the
/// candidate fleet vehicles, the filter state above the grid, and the
/// confirm action.
///
/// A real router would pass the request id in as a navigation argument;
/// until that exists, [load] defaults to the demo request from the design
/// (`REQ-1042`) exactly like `DispatcherDashboardProvider`'s seed data.
class VehicleAssignmentProvider extends ChangeNotifier with ViewStateMixin {
  VehicleAssignmentProvider({required AdminRepository repository})
    : _repository = repository;

  final AdminRepository _repository;

  static const String defaultRequestId = 'REQ-1042';

  ReservationRequestModel? _request;
  List<FleetVehicleModel> _allVehicles = const [];
  String? _selectedVehicleId;

  int _minSeats = 0;
  bool _availableOnly = true;
  String _searchQuery = '';

  bool _confirming = false;

  ReservationRequestModel? get request => _request;
  String? get selectedVehicleId => _selectedVehicleId;
  int get minSeats => _minSeats;
  bool get availableOnly => _availableOnly;
  bool get isConfirming => _confirming;

  FleetVehicleModel? get selectedVehicle {
    if (_selectedVehicleId == null) return null;
    for (final v in _allVehicles) {
      if (v.id == _selectedVehicleId) return v;
    }
    return null;
  }

  List<FleetVehicleModel> get filteredVehicles {
    return _allVehicles.where((vehicle) {
      if (_minSeats > 0 && vehicle.seatCapacity < _minSeats) return false;
      if (_availableOnly && !vehicle.isSelectable) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        if (!vehicle.name.toLowerCase().contains(q) &&
            !vehicle.id.toLowerCase().contains(q)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  Future<void> load([String requestId = defaultRequestId]) async {
    setLoading();
    try {
      final result = await _repository.fetchAssignmentContext(requestId);
      _request = result.request;
      _allVehicles = result.vehicles;

      // Pre-select the first available vehicle, matching the "Current
      // Selection" state shown in the design.
      _selectedVehicleId = _allVehicles
          .firstWhere(
            (v) => v.isSelectable,
            orElse: () => _allVehicles.first,
          )
          .id;

      // Default the seat filter to the request's own requirement.
      _minSeats = _request?.passengerCount ?? 0;

      setSuccess();
    } catch (error) {
      setError('Could not load vehicle options. Please try again.');
    }
  }

  void selectVehicle(String vehicleId) {
    final vehicle = _allVehicles.where((v) => v.id == vehicleId).firstOrNull;
    if (vehicle == null || !vehicle.isSelectable) return;
    _selectedVehicleId = vehicleId;
    notifyListeners();
  }

  void setMinSeats(int value) {
    _minSeats = value;
    notifyListeners();
  }

  void setAvailableOnly(bool value) {
    _availableOnly = value;
    notifyListeners();
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  /// Returns `true` on success. The caller decides what happens next
  /// (currently: a snackbar, since Driver Assignment isn't built yet).
  Future<bool> confirmAssignment() async {
    final requestId = _request?.id;
    final vehicleId = _selectedVehicleId;
    if (requestId == null || vehicleId == null || _confirming) return false;

    _confirming = true;
    notifyListeners();

    try {
      await _repository.confirmAssignment(
        requestId: requestId,
        vehicleId: vehicleId,
      );
      return true;
    } catch (error) {
      setError('Could not confirm the assignment. Please try again.');
      return false;
    } finally {
      _confirming = false;
      notifyListeners();
    }
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
