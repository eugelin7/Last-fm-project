import 'package:flutter/foundation.dart';

// This class (SearchFieldState) is used when we want to show/hide
// the virtual keyboard. We need to track the state of the search field.

// Actually we don't need ChangeNotifier here as we use this class
// only as shared storage of Search Field State.
// But Provider requires descendants of ChangeNotifier

class SearchFieldState extends ChangeNotifier {
  bool _isFocused = false;
  bool _doRefocus = true;

  bool get isFocused => _isFocused;
  bool get doRefocus => _doRefocus;

  void setFocusedStateTo(bool state) {
    _isFocused = state;
    // we don't need to notify listeners
    // it's just a shared state to read
  }

  void setDoRefocusTo(bool doRefocus) {
    _doRefocus = doRefocus;
    // we don't need to notify listeners
    // it's just a shared state to read
  }
}
