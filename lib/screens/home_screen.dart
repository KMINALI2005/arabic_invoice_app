import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/invoice_provider.dart';
import 'invoice_editor_screen.dart';
import '../models/invoice.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('تطبيق الفواتير')),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Row(children: [
                Expanded(child: _card(context, Icons.settings, 'الإعدادات')),
                const SizedBox(width: 12),
                Expanded(child: _card(context, Icons.list, 'الفواتير')),
                const SizedBox(width: 12),
                Expanded(child: GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InvoiceEditorScreen())), child: _card(context, Icons.add, 'إنشاء فاتورة', accent: true))),
              ]),
              const SizedBox(height: 18),
              const Align(alignment: Alignment.centerRight, child: Text('الفواتير المحفوظة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              const SizedBox(height: 8),
              Expanded(child: Consumer<InvoiceProvider>(builder: (ctx, prov, _) {
                if (prov.loading) return const Center(child: CircularProgressIndicator());
                if (prov.invoices.isEmpty) return Center(child: Text('لا توجد فواتير بعد', style: TextStyle(color: Colors.grey[600])));
                return ListView.builder(
                  itemCount: prov.invoices.length,
                  itemBuilder: (c, i) {
                    final inv = prov.invoices[i];
                    return Card(
                      child: ListTile(
                        title: Text(inv.customer),
                        subtitle: Text('الإجمالي: ${inv.total.toStringAsFixed(2)} ر.س'),
                        trailing: IconButton(icon: const Icon(Icons.picture_as_pdf), onPressed: () => _exportPdf(inv)),
                      ),
                    );
                  },
                );
              }))
            ],
          ),
        ),
      ),
    );
  }

  Widget _card(BuildContext c, IconData ic, String title, {bool accent = false}) => Card(
    color: accent ? const Color(0xFFEF6C00) : null,
    child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [Icon(ic, size: 36, color: accent ? Colors.white : null), const SizedBox(height: 8), Text(title, style: accent ? const TextStyle(color: Colors.white) : null)])),
  );

  Future<void> _exportPdf(Invoice inv) async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(build: (c) => pw.Directionality(textDirection: pw.TextDirection.rtl, child: pw.Center(child: pw.Text('فاتورة')))));
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
