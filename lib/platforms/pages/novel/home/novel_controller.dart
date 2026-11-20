import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/platforms/pages/novel/models/novel_file.dart';
import 'package:than_reader/platforms/pages/novel/home/novel_file_scanner.dart';

class NovelControllerStateChanged extends IControllerEvent {}

class NovelController extends IController {
  List<NovelFile> list = [];
  bool isLoading = false;
  String? error;

  @override
  Future<void> init() async {}

  Future<void> fetchList() async {
    try {
      isLoading = true;
      error = null;
      addEvent(NovelControllerStateChanged());

      list = await NovelFileScanner.scanAll();

      isLoading = false;
      addEvent(NovelControllerStateChanged());
    } catch (e) {
      error = e.toString();
      isLoading = false;
      addEvent(NovelControllerStateChanged());
    }
  }

  Future<void> rename(NovelFile file, String newPath) async {
    try {
      final oldF = File(file.path);
      final newF = File(newPath);
      if (newF.existsSync()) return;
      await oldF.rename(newPath);
      final index = list.indexWhere((e) => e.path == file.path);
      if (index == -1) return;
      list[index] = file.copyWith(
        name: newF.onlyName,
        ext: newF.extName,
        path: newF.path,
        size: newF.size,
        date: newF.modifiedDate,
      );
      addEvent(NovelControllerStateChanged());
    } catch (e) {
      error = e.toString();
      addEvent(NovelControllerStateChanged());
    }
  }

  Future<void> delete(NovelFile file) async {
    try {
      final oldF = File(file.path);
      await oldF.deleteSafe();

      final index = list.indexWhere((e) => e.path == file.path);
      list.removeAt(index);
      addEvent(NovelControllerStateChanged());
    } catch (e) {
      error = e.toString();
      addEvent(NovelControllerStateChanged());
    }
  }
}
