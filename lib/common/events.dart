import 'dart:async';

abstract class AppEvent {}

typedef EventBus = StreamController<AppEvent>;
typedef EventSink = Sink<AppEvent>;
typedef EventStream = Stream<AppEvent>;
typedef EventStreamSubscription = StreamSubscription<AppEvent>;