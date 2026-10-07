import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/platforms/pages/novel/novel_file.dart';
import 'package:than_reader/platforms/pages/novel/novel_file_scanner.dart';

class NovelControllerStateChanged extends IControllerEvent {}

class NovelController extends IController {
  List<NovelFile> list = [];
  bool isLoading = false;

  @override
  Future<void> init() async {}

  Future<void> fetchList() async {
    try {
      isLoading = true;
      addEvent(NovelControllerStateChanged());

      list = await NovelFileScanner.scanAll();

      isLoading = false;
      addEvent(NovelControllerStateChanged());
    } catch (e) {
      isLoading = false;
      addEvent(NovelControllerStateChanged());
    }
  }
}
