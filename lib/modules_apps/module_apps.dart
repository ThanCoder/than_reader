import 'package:flutter/material.dart';

abstract class IModuleAppParams {}

abstract class IModuleAppResponse {}

abstract class IModuleApp<
  P extends IModuleAppParams,
  R extends IModuleAppResponse
> {
  String get appId;
  Future<R?> go(BuildContext context, P params);
}

// empty
class ModuleAppParamsEmpty extends IModuleAppParams {}

class ModuleAppResponseEmpty extends IModuleAppResponse {}

class ModuleApps {
  static ModuleApps instance = ModuleApps._();
  ModuleApps._();
  factory ModuleApps() => instance;

  final Map<String, IModuleApp> apps = {};

  void registerModule(IModuleApp app) {
    if (apps.containsKey(app.appId)) {
      throw StateError('Module app already registered: `${app.appId}`');
    }

    apps[app.appId] = app;
  }

  Future<R?> go<P extends IModuleAppParams, R extends IModuleAppResponse>(
    BuildContext context, {
    required String appId,
    required P params,
  }) async {
    final app = apps[appId];

    if (app == null) {
      throw StateError('No module app registered for appId `$appId`');
    }

    final typedApp = app as IModuleApp<P, R>;
    return await typedApp.go(context, params);
  }
}
