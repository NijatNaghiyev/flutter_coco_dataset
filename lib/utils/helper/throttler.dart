class Throttler {
  final int milliseconds;
  bool _isThrottled = false;

  Throttler({required this.milliseconds});

  void call(void Function() action) {
    if (!_isThrottled) {
      _isThrottled = true;
      action();
      
      Future.delayed(Duration(milliseconds: milliseconds), () {
        _isThrottled = false;
      });
    }
  }
}