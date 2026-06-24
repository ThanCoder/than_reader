import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:t_widgets/t_widgets.dart';

class PdfrxScreen extends StatefulWidget {
  final String path;
  final String? password;
  const PdfrxScreen({super.key, required this.path, required this.password});

  @override
  State<PdfrxScreen> createState() => _PdfrxScreenState();
}

class _PdfrxScreenState extends State<PdfrxScreen> {
  final controller = PdfViewerController();
  final loadingNotifier = ValueNotifier<bool>(false);
  final pageChangedNotifier = ValueNotifier<(int, int)>((0, 0));

  @override
  void initState() {
    loadingNotifier.value = true;
    super.initState();
  }

  void onDocumentLoadFinished() {
    loadingNotifier.value = false;
    pageChangedNotifier.value = (controller.pageCount, controller.pageNumber!);
    // controller.goToPage(pageNumber: 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.path.getName())),
      body: mainWidget,
    );
  }

  PdfViewerParams get params => PdfViewerParams(
    textSelectionParams: PdfTextSelectionParams(enabled: false),
    scrollByMouseWheel: 2,
    scrollByArrowKey: 40,
    margin: 0,
    onDocumentLoadFinished: (documentRef, loadSucceeded) =>
        onDocumentLoadFinished(),
    onPageChanged: (pageNumber) {
      if (pageNumber == null) return;
      pageChangedNotifier.value = (controller.pageCount, pageNumber);
    },

    // panEnabled: false,
    // panAxis: PanAxis.vertical,
  );

  Widget get mainWidget {
    return Stack(
      children: [
        // pdf
        Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              top: 50,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.white,
                  BlendMode.difference,
                ),
                child: PdfViewer.file(
                  useProgressiveLoading: false,
                  widget.path,
                  controller: controller,
                  params: params,
                ),
              ),
            ),
          ],
        ),

        // header
        Positioned(top: 0, left: 0, right: 0, child: headerWidget),
        Positioned(top: 0, left: 0, right: 0, child: loaderWidget),
      ],
    );
  }

  Widget get headerWidget {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 5,
          children: [
            ValueListenableBuilder<(int, int)>(
              valueListenable: pageChangedNotifier,
              builder: (context, value, child) {
                return GestureDetector(
                  onTap: showGoToDialog,
                  child: Text(
                    '${value.$2}/${value.$1}',
                    style: TextStyle(color: Colors.blue),
                  ),
                );
              },
            ),
            IconButton(
              onPressed: () {
                controller.zoomDown();
              },
              icon: Icon(Icons.zoom_out),
            ),
            IconButton(
              onPressed: () {
                controller.zoomUp();
              },
              icon: Icon(Icons.zoom_in),
            ),
          ],
        ),
      ),
    );
  }

  Widget get loaderWidget {
    return ValueListenableBuilder(
      valueListenable: loadingNotifier,
      builder: (context, value, child) {
        if (value) {
          return LinearProgressIndicator();
        }
        return SizedBox.shrink();
      },
    );
  }

  void showGoToDialog() {
    final pageNumber = controller.pageNumber!;
    final pageCount = controller.pageCount;
    showTReanmeDialog(
      context,
      text: pageNumber.toString(),
      textInputType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      submitText: 'Go To',
      onCheckIsError: (text) {
        final num = int.tryParse(text) ?? 0;
        if (num > pageCount) {
          return '$num > $pageCount';
        }
        return null;
      },
      onSubmit: (text) {
        controller.goToPage(pageNumber: int.parse(text));
      },
    );
  }
}
