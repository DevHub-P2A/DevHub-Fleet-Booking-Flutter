import 'package:flutter/foundation.dart';

import '../../../core/state/view_state.dart';
import '../data/admin_repository.dart';
import '../models/admin_profile_model.dart';

class AdminProfileProvider extends ChangeNotifier with ViewStateMixin {
  AdminProfileProvider({required AdminRepository repository})
    : _repository = repository;

  final AdminRepository _repository;

  AdminProfileModel? _profile;
  AdminProfileModel? get profile => _profile;

  Future<void> load() async {
    setLoading();
    try {
      _profile = await _repository.fetchProfile();
      setSuccess();
    } catch (error) {
      setError('Could not load the admin profile. Please try again.');
    }
  }
}
