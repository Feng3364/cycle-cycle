import 'dart:async';
import 'dart:collection';
import 'dart:ui';

import 'package:flutter/foundation.dart';

enum AsyncLevel { future, microtask }

class AsyncManager {
  ///--------------------单例-------------------///

  AsyncManager._internal();

  factory AsyncManager() => _instance;

  static final AsyncManager _instance = AsyncManager._internal();

  ///--------------------属性-------------------///

  Queue<Future> messageQueue = DoubleLinkedQueue();

  ///--------------------方法-------------------///

  void addSyncTask(VoidCallback callback) {
    Future.sync(() => callback());
  }

  void addDelayTask(VoidCallback callback, Duration duration) {
    Future.delayed(duration, callback);
  }

  void addAsyncTask(VoidCallback callback, AsyncLevel level) {
    if (level == AsyncLevel.future) {
      Future(() => callback());
    } else {
      scheduleMicrotask(() => callback());
      Future.microtask(() => callback());
    }
  }

  void _handleTask() {}

  void _handleError() {}

  void _handleComplete() {}

  void _handleCancel() {}
}
