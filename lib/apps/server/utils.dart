import 'dart:async';
import 'dart:io';

Future<String?> findActiveHostAddress({required int port}) async {
  final interfaces = await NetworkInterface.list(
    type: InternetAddressType.IPv4,
    includeLoopback: false,
  );

  for (final interface in interfaces) {
    for (final address in interface.addresses) {
      final parts = address.address.split('.');

      if (parts.length != 4) continue;

      final subnet = '${parts[0]}.${parts[1]}.${parts[2]}';

      final futures = <Future<String?>>[];

      for (var i = 1; i <= 254; i++) {
        final host = '$subnet.$i';

        futures.add(
          Socket.connect(host, port, timeout: const Duration(milliseconds: 300))
              .then((socket) async {
                await socket.close();
                return 'http://$host:$port';
              })
              .catchError((_) => ''),
        );
      }

      final results = await Future.wait(futures);

      for (final result in results) {
        if (result != null && result.isNotEmpty) {
          return result;
        }
      }
    }
  }

  return null;
}
