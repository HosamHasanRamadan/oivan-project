import 'dart:developer';

import 'package:notification_dispatcher/notification_dispatcher.dart';

enum GlobalEvent {
  bookMarkAdded,
  bookMarkDeleted,
  userUpdated,
}

typedef EventSubscriptionDisposer = void Function();
typedef OnEvent = void Function(Map<String, dynamic>? event);

interface class GlobalEventBus {
  /// Drops event if sender same as the receiver
  static EventSubscriptionDisposer subscribe<T>({
    required OnEvent onEvent,
    required String eventName,
    Object? receiver,
  }) {
    final object = Object();

    NotificationDispatcher.instance.addObserver(
      object,
      name: eventName,
      callback: (data) {
        log('Received: R:$receiver\nS:${data.sender}\n${data.info}');
        // drop of sender is the receiver
        // only when receiver or sender not null
        if ((receiver == data.sender) && receiver != null) {
          log('Dropped => Received: R:$receiver\nS:${data.sender}\n${data.info}');
          return;
        }
        onEvent(data.info);
      },
    );
    return () => NotificationDispatcher.instance.removeObserverWith(
          object,
          name: eventName,
        );
  }

  static void sendEvent({
    required String name,
    Map<String, dynamic>? payload,
    Object? sender,
  }) {
    log('Event:$name\nPayload:$payload\nS$sender');
    NotificationDispatcher.instance.post(
      sender: sender,
      name: name,
      info: payload,
    );
  }
}
