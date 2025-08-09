import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/invoice.dart';

class StorageService {
  Future<File> _file() async {
    final d = await getApplicationDocumentsDirectory();
    return File('${d.path}/invoices.json');
  }

  Future<List<Invoice>> loadInvoices() async {
    try {
      final f = await _file();
      if (!await f.exists()) return [];
      final s = await f.readAsString();
      final data = jsonDecode(s) as List<dynamic>;
      return data.map((e) => Invoice.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveInvoices(List<Invoice> invoices) async {
    final f = await _file();
    final s = jsonEncode(invoices.map((i) => i.toJson()).toList());
    await f.writeAsString(s);
  }
}
