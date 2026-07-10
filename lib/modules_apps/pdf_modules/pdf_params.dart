// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:than_pkg/than_pkg.dart';

class PdfParams {
  final String path;
  final String? password;
  final String configPath;
  PdfParams({required this.path, required this.configPath, this.password});
}

class PdfResult {}

enum PdfThemeMode {
  systemFollow,
  appFollow,
  light,
  dark;

  static PdfThemeMode fromName(String name) {
    if (name == systemFollow.name) return .systemFollow;
    if (name == light.name) return .light;
    if (name == dark.name) return .dark;
    return .appFollow;
  }
}

enum PdfReaderType {
  autoReader,
  thanPdfReader,
  pdfrxReader;

  static PdfReaderType fromName(String name) {
    if (name == thanPdfReader.name) return .thanPdfReader;
    if (name == pdfrxReader.name) return .pdfrxReader;
    return .autoReader;
  }
}


class PdfBookmark {
  final int page;
  final String title;
  PdfBookmark({required this.page, required this.title});

  PdfBookmark copyWith({int? page, String? title}) {
    return PdfBookmark(page: page ?? this.page, title: title ?? this.title);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'page': page, 'title': title};
  }

  factory PdfBookmark.fromMap(Map<String, dynamic> map) {
    return PdfBookmark(
      page: map.getInt(['page']),
      title: map.getString(['title'], def: 'Untitled'),
    );
  }
}
