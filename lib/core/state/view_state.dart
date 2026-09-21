import 'package:flutter/foundation.dart';

/// The four states any screen backed by a repository can be in.
///
/// Every `ChangeNotifier` in the app exposes a `ViewState` so the UI has one
/// consistent way to decide between a spinner, an error, an empty state, and
/// real content. When the real API arrives nothing here changes.
enum ViewState { idle, loading, success, error }

/// Mixin for providers so they don't each re-declare the same three fields.
///
/// Scoped `on ChangeNotifier` so `notifyListeners()` is guaranteed to exist.
mixin ViewStateMixin on ChangeNotifier {
  ViewState _state = ViewState.idle;
  String? _errorMessage;

  ViewState get state => _state;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _state == ViewState.loading;
  bool get hasError => _state == ViewState.error;

  void setLoading() {
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void setSuccess() {
    _state = ViewState.success;
    _errorMessage = null;
    notifyListeners();
  }

  void setError(String message) {
    _state = ViewState.error;
    _errorMessage = message;
    notifyListeners();
  }
}
