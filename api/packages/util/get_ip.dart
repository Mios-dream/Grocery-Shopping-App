import 'dart:io';

Future<String> getHostIP() async {
  try {
    final addresses =
        await InternetAddress.lookup('localhost');
    for (final address in addresses) {
      if (address.type == InternetAddressType.IPv4) {
        return address.address;
      }
    }
  } catch (e) {
    // print('Error getting host IP: $e');
  }
  return '127.0.0.1';
}
