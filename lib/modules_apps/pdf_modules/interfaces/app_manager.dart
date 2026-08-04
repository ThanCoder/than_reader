import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

abstract class ModuleApp<P, R> {
  Future<R?> go(BuildContext context, P params);
}

class AppManager {
  static AppManager instance = AppManager._();
  AppManager._();
  factory AppManager() => instance;

  final Map<Type, ModuleApp> _loadedApps = {};

  void register(ModuleApp app) {
    _loadedApps[app.runtimeType] = app;
  }

  Future<R?> go<T extends ModuleApp<P, R>, P, R>(
    BuildContext context,
    P params,
  ) async {
    final app = _loadedApps[T];
    if (app == null) {
      showTMessageDialogError(context, 'Need To Register `$T`');
      return null;
    }
    return await (app as T).go(context, params);
  }
}
