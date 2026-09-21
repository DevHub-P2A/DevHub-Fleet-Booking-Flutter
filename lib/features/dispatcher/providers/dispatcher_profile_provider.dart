import 'package:flutter/foundation.dart';

import '../../../core/state/view_state.dart';
import '../data/dispatcher_repository.dart';
import '../models/dispatcher_profile_model.dart';

class DispatcherProfileProvider extends ChangeNotifier with ViewStateMixin {
  DispatcherProfileProvider({required DispatcherRepository repository})
    : _repository = repository;

  final DispatcherRepository _repository;

  DispatcherProfileModel? _profile;
  DispatcherProfileModel? get profile => _profile;

  Future<void> load() async {
    setLoading();
    try {
      _profile = await _repository.fetchProfile();
      setSuccess();
    } catch (error) {
      setError('Could not load your profile. Please try again.');
    }
  }
}
