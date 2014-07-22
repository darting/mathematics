part of mathematics;




class EventStream<T> {
  StreamController<T> _controller;
  Stream<T> _stream;
  List<StreamSubscription> _subscriptions;


  EventStream() {
    _controller = new StreamController.broadcast(sync: true);
    _stream = _controller.stream;
    _subscriptions = [];
  }

  StreamSubscription<T> listen(void onData(T data)) {
    var subscription = _stream.listen(onData);
    _subscriptions.add(subscription);
    return subscription;
  }

  void dispatch(T data) {
    _controller.add(data);
  }

  void cancelSubscriptions() {
    _subscriptions.forEach((s) => s.cancel());
    _subscriptions.clear();
  }
}
