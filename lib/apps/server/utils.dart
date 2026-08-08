import 'dart:io';

Future<String?> findActiveHostAddress({required int port}) async {
  // final res = await ThanPkg.android.wifi.getWifiAddressList();
  // devPrint(res);

  final interfaces = await NetworkInterface.list(
    type: InternetAddressType.IPv4,
    includeLoopback: false,
  );
  // print(interfaces);

  for (final interface in interfaces) {
    for (final address in interface.addresses) {
      final localIp = address.address;

      final parts = localIp.split('.');
      if (parts.length != 4) continue;

      // 127.x.x.x မဖြစ်စေချင်
      if (parts[0] == '127') continue;

      final subnet = '${parts[0]}.${parts[1]}.${parts[2]}';

      final futures = <Future<String?>>[];

      for (var i = 1; i <= 254; i++) {
        final host = '$subnet.$i';

        if (host == localIp) continue;

        futures.add(checkHost(host, port));
      }

      final results = await Future.wait(futures);

      for (final result in results) {
        if (result != null) {
          return result;
        }
      }
    }
  }

  return null;
}

Future<String?> checkHost(String host, int port) async {
  try {
    final socket = await Socket.connect(
      host,
      port,
      timeout: const Duration(milliseconds: 500),
    );

    await socket.close();

    return 'http://$host:$port';
  } catch (_) {
    return null;
  }
}
