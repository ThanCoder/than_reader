import 'package:than_reader/core/controller/all_files/all_file_state.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/core/utils/file_scanner.dart';

/// ***********Events******************
class AllFileControllerLoaded extends IControllerEvent {}

class AllFileControllerError extends IControllerEvent {
  final String message;
  AllFileControllerError(this.message);
}

class AllFileControllerLoading extends IControllerEvent {}

/// ***********Events******************

class AllFileController extends IController {
  @override
  Future<void> init() async {}

  List<ReaderFile> _list = [];
  List<ReaderFile> get list => _list;

  AllFileState _state = .new(isLoading: false);
  AllFileState get state => _state;

  Future<void> loadAll({bool useCache = true}) async {
    try {
      _state = _state.copyWith(isLoading: true);
      addEvent(AllFileControllerLoading());

      _list = await FileScanner.scanAll();
      _state = _state.copyWith(isLoading: false);

      addEvent(AllFileControllerLoaded());
    } catch (e) {
      _state = _state.copyWith(isLoading: false);
      addEvent(AllFileControllerError(e.toString()));
    }
  }
}
