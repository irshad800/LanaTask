import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/io_client.dart';

class ApiClient {
  Future<http.Client> getClient() async {
    final SecurityContext securityContext = SecurityContext(withTrustedRoots: true);
    final ByteData data = await rootBundle.load('assets/certificates/cert.pem');
    securityContext.setTrustedCertificatesBytes(data.buffer.asUint8List());

    final HttpClient client = HttpClient(context: securityContext);
    return IOClient(client);
  }
}
