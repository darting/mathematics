part of mathematics;

class EventTrigger {

  Map<String, EventStream> _streams = {};

  EventStream on(String type) {
    EventStream stream = _streams[type];
    if (stream == null) {
      stream = new EventStream();
      _streams[type] = stream;
    }
    return stream;
  }

  void cancelSubscriptions() {
    _streams.forEach((k, v) => v.cancelSubscriptions());
  }

}
