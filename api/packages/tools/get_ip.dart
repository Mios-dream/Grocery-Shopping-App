import 'dart:io';

Future<String> getHostIp() async {
  try {
    final addresses =
        await InternetAddress.lookup('localhost');
    for (final address in addresses) {
      if (address.type == InternetAddressType.IPv4) {
        return address.address;
      }
    }
  } catch (e) {
    print('Error getting host IP: $e');
  }
  return '127.0.0.1'; // 默认返回本地回环地址
}
