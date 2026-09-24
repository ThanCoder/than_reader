import 'package:flutter/material.dart';
import 'package:t_pdf_reader/t_pdf_reader.dart';
import 'package:than_reader/const_keys.dart';
import 'package:than_reader/core/utils/app_utils.dart';

extension IPageImageWorkerTypeX on IPageImageWorkerType {
  static IPageImageWorkerType fromValue(String val) {
    return IPageImageWorkerType.values.firstWhere(
      (e) => e.name == val,
      orElse: () => .singleThread,
    );
  }
}

class PdfReaderPerferRenderThread extends StatefulWidget {
  const new({super.key});

  static IPageImageWorkerType get currentThread =>
      IPageImageWorkerTypeX.fromValue(
        AppUtil.instance.config.getString(
          pdfReaderPreferPageImageRenderThreadTypeKey,
        ),
      );

  @override
  State<PdfReaderPerferRenderThread> createState() =>
      _PdfReaderPerferRenderThreadState();
}

class _PdfReaderPerferRenderThreadState
    extends State<PdfReaderPerferRenderThread> {
  final cf = AppUtil.instance.config;

  final items = IPageImageWorkerType.values
      .map(
        (e) => DropdownMenuItem<IPageImageWorkerType>(
          value: e,
          child: Text(e.label),
        ),
      )
      .toList();
  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        border: .all(color: col.outlineVariant),
        borderRadius: .circular(14),
        color: col.surfaceContainer,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              spacing: 4,
              children: [
                Text(
                  'Perfer Page Image Thread',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: .w700,
                    color: col.onSurface,
                  ),
                ),
                Text(
                  'Automatically selects the appropriate Thread while reading PDFs.',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: .w400,
                    color: col.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder(
            stream: cf.stream.put.where(
              (e) => e.key == pdfReaderPreferPageImageRenderThreadTypeKey,
            ),
            builder: (context, asyncSnapshot) {
              final type = IPageImageWorkerTypeX.fromValue(
                cf.getString(pdfReaderPreferPageImageRenderThreadTypeKey),
              );
              return DropdownButtonHideUnderline(
                child: DropdownButton<IPageImageWorkerType>(
                  borderRadius: .circular(15),
                  value: type,
                  items: items,
                  onChanged: (value) {
                    cf.putAndWriteAll(
                      pdfReaderPreferPageImageRenderThreadTypeKey,
                      value!.name,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/*
english version ရေးပေး

 Row(
        children: [
          Column(
            crossAxisAlignment: .start,
            spacing: 4,
            children: [
              Text(
                'Perfer Render Page Image Thread',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: .w700,
                  color: col.onSurface,
                ),
              ),
              Text(
                'desc',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: .w400,
                  color: col.onSurfaceVariant,
                ),
              ),
            ],
          ),
          Spacer(),
          StreamBuilder(
            stream: cf.stream.put.where(
              (e) => e.key == pdfReaderPreferPageImageRenderThreadTypeKey,
            ),
            builder: (context, asyncSnapshot) {
              final type = IPageImageWorkerTypeX.fromValue(
                cf.getString(pdfReaderPreferPageImageRenderThreadTypeKey),
              );
              return DropdownButtonHideUnderline(
                child: DropdownButton<IPageImageWorkerType>(
                  borderRadius: .circular(15),
                  value: type,
                  items: items,
                  onChanged: (value) {
                    cf.putAndWriteAll(
                      pdfReaderPreferPageImageRenderThreadTypeKey,
                      value!.name,
                    );
                  },
                ),
              );
            },
          ),
        ],
*/
