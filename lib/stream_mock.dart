import 'dart:async';

class SecondsStream {
  final StreamController<int> _controller = StreamController<int>();
  Timer? _timer;

  SecondsStream() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _controller.add(DateTime.now().second);
    });
  }

  Stream<int> get stream => _controller.stream;

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}