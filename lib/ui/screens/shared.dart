import 'package:flutter/cupertino.dart';

class SharedRepo extends ChangeNotifier {
  bool _isSavedAlbumsNeedsReLoading = true;

  bool get isSavedAlbumsNeedsReLoading => _isSavedAlbumsNeedsReLoading;

  void savedAlbumsNeedsReLoading(bool v) {
    _isSavedAlbumsNeedsReLoading = v;
    notifyListeners();
  }

  void savedAlbumsReLoadingFinished() {
    _isSavedAlbumsNeedsReLoading = false;
  }
}
