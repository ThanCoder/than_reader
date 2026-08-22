import 'dart:async';

abstract class IControllerEvent {
  const IControllerEvent();
}

abstract class IController {
  Future<void> init();

  final _con = StreamController<IControllerEvent>.broadcast();
  Stream<IControllerEvent> get events => _con.stream;

  void addEvent(IControllerEvent event) {
    if (!_con.isClosed) {
      _con.add(event);
    }
  }

  Future<void> dispose() async {
    await _con.close();
  }
}

class ControllerManager {
  // static ControllerManager instance = ControllerManager._();
  // ControllerManager._();
  // factory ControllerManager() => instance;

  static final Map<Type, IController> _map = {};

  static void register(IController controller) {
    final t = controller.runtimeType;
    if (_map.containsKey(t)) {
      throw Exception('Type ရှိနေပြီးသားဖြစ်နေတယ်; Type $t');
    }
    _map[t] = controller;
  }

  static T read<T extends IController>() {
    final val = _map[T];
    if (val == null) {
      throw Exception('Type: `$T` Not Registered!');
    }
    return val as T;
  }

  static Future<void> initAll() async {
    for (var val in _map.values) {
      await val.init();
    }
  }

  static Future<void> dispose<T extends IController>() async {
    final val = _map[T];
    if (val == null) return;
    await val.dispose();
    _map.remove(T);
  }

  static Future<void> disposeAll() async {
    for (final controller in _map.values) {
      await controller.dispose();
    }

    _map.clear();
  }
}

extension IControllerExt on Stream<IControllerEvent> {
  Stream<T> whereType<T extends IControllerEvent>() {
    return where((e) => e is T).cast<T>();
  }
}
