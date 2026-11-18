import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:than_pkg_linux/core/utils/path_ext.dart';
import 'package:than_pkg_linux/than_pkg_linux.dart';
import 'package:than_reader/ui/build_context_x.dart';
import 'package:than_reader/ui/dialog/success_alert_dialog.dart';

class CreateLinuxDesktopIcon extends StatefulWidget {
  const new({
    super.key,
    required this.desktopFileName,
    required this.assetIconPath,
    this.extname = 'desktop',
    required this.name,
    required this.genericName,
    required this.categories,
    required this.comment,
  });
  final String desktopFileName;
  final String extname;

  /// assets/logo/app-icon.png
  final String assetIconPath;

  /// Name=TVP media player
  final String name;

  /// GenericName=Media player
  final String genericName;

  /// Categories=AudioVideo;Player;Recorder;
  final String categories;

  /// Comment=Read, capture, broadcast your multimedia streams
  final String comment;

  @override
  State<CreateLinuxDesktopIcon> createState() => _CreateLinuxDesktopIconState();
}

class _CreateLinuxDesktopIconState extends State<CreateLinuxDesktopIcon> {
  final pkg = ThanPkgLinux.getInstance.pathHandler;

  void _createDesktop() async {
    final env = Platform.environment['HOME'];
    if (env == null) return;
    final desktopF = File(
      env.join('Desktop').join('${widget.desktopFileName}.${widget.extname}'),
    );
    final execPath = Platform.resolvedExecutable;
    final contents = createDesktopData(
      execPath,
      pkg.getExecutableFlutterAssetsPath().join(widget.assetIconPath),
      name: widget.name,
      categories: widget.categories,
      comment: widget.comment,
      genericName: widget.genericName,
    );
    await desktopF.writeAsString(contents);
    if (!mounted) return;
    showSuccessDialog(context, 'Desktop File Created');
  }

  @override
  Widget build(BuildContext context) {
    final col = context.colorScheme;

    return ListTile(
      title: Text('Create Desktop Icon'),
      tileColor: col.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: .circular(15)),
      leading: Icon(Icons.install_desktop_outlined),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: _createDesktop,
    );
  }
}

String createDesktopData(
  String execPath,
  String iconPath, {
  required String name,
  required String genericName,
  required String categories,
  required String comment,
}) {
  return """
[Desktop Entry]
Version=1.0
Type=Application
Name=$name
GenericName=$genericName
Comment=$comment
TryExec=$execPath
StartupNotify=true
Exec=$execPath %U
Icon=$iconPath
Categories=$categories

""";
}

// X-KDE-Protocols=ftp,http,https,mms,rtmp,rtsp,sftp,smb
// Keywords=Player;Capture;DVD;Audio;Video;Server;Broadcast;

// X-KDE-Protocols=ftp,http,https,mms,rtmp,rtsp,sftp,smb
// Keywords=Player;Capture;DVD;Audio;Video;Server;Broadcast;
