import 'dart:async';
import 'package:flutter/material.dart';

/// 异常捕获
void enterCatchZone({
  Function? catchHandler,
  Widget? widget,
  Function? errorHandler,
}) {
  void onError(Object error, StackTrace? stack) {
    if (errorHandler != null) {
      errorHandler(error, stack);
    } else {
      debugPrint('捕获到了异常——${error.toString()}');
    }
  }

  runZonedGuarded(() async {
    // 自定义捕获处理
    if (catchHandler != null) {
      catchHandler();
    } else {
      // 框架默认捕获异常
      WidgetsFlutterBinding.ensureInitialized();
      FlutterError.onError = (FlutterErrorDetails details) {
        onError(details.exception, details.stack);
      };
    }

    // 默认运行Widget
    if (widget != null) {
      runApp(widget);
    }
  }, (Object error, StackTrace stack) {
    onError(error, stack);
  });
}
