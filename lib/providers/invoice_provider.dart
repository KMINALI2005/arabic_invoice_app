import 'package:flutter/foundation.dart';
import '../models/invoice.dart';
import '../services/storage_service.dart';

class InvoiceProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  List<Invoice> _invoices = [];
  bool _loading = true;

  List<Invoice> get invoices => _invoices;
  bool get loading => _loading;

  InvoiceProvider() { load(); }

  Future<void> load() async {
    _loading = true; notifyListeners();
    _invoices = await _storage.loadInvoices();
    _loading = false; notifyListeners();
  }

  Future<void> addInvoice(Invoice inv) async {
    _invoices.add(inv);
    await _storage.saveInvoices(_invoices);
    notifyListeners();
  }

  Future<void> removeInvoice(int index) async {
    _invoices.removeAt(index);
    await _storage.saveInvoices(_invoices);
    notifyListeners();
  }
}
