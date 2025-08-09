import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/invoice.dart';
import '../providers/invoice_provider.dart';

class InvoiceEditorScreen extends StatefulWidget {
  const InvoiceEditorScreen({super.key});

  @override
  State<InvoiceEditorScreen> createState() => _InvoiceEditorScreenState();
}

class _InvoiceEditorScreenState extends State<InvoiceEditorScreen> {
  final _customerCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  final List<InvoiceItem> _items = [InvoiceItem(description: 'مثال: خدمة تصميم', qty: 1, unitPrice: 0.0)];
  final _notes = TextEditingController();

  double get total => _items.fold(0, (s, it) => s + it.qty * it.unitPrice);

  void _addRow() { setState(() => _items.add(InvoiceItem(description: '', qty: 1, unitPrice: 0.0))); }
  void _removeRow(int i) { setState(() => _items.removeAt(i)); }

  Future<void> _pickDate() async {
    final d = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2000), lastDate: DateTime(2100), builder: (ctx, child) => Directionality(textDirection: TextDirection.rtl, child: child!));
    if (d != null) setState(() => _date = d);
  }

  void _save() async {
    final inv = Invoice(customer: _customerCtrl.text, date: DateFormat('dd / MM / yyyy').format(_date), items: _items, notes: _notes.text);
    await Provider.of<InvoiceProvider>(context, listen: false).addInvoice(inv);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('إنشاء فاتورة')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(children: [
            TextField(controller: _customerCtrl, decoration: const InputDecoration(labelText: 'اسم الزبون')),
            const SizedBox(height: 12),
            Row(children: [Expanded(child: TextField(readOnly: true, onTap: _pickDate, controller: TextEditingController(text: DateFormat('dd / MM / yyyy').format(_date)), decoration: const InputDecoration(prefixIcon: Icon(Icons.calendar_today), labelText: 'تاريخ الفاتورة')))]),
            const SizedBox(height: 18),
            ListView.separated(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: _items.length, separatorBuilder: (_,__) => const SizedBox(height: 8), itemBuilder: (c,i){
              final it = _items[i];
              return Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(children: [
                TextField(controller: TextEditingController(text: it.description), onChanged: (v){ it.description = v; }, decoration: const InputDecoration(labelText: 'الوصف')),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(child: TextField(controller: TextEditingController(text: it.qty.toString()), keyboardType: TextInputType.numberWithOptions(decimal: true), onChanged: (v){ it.qty = double.tryParse(v) ?? 0; }, decoration: const InputDecoration(labelText: 'العدد'))),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: TextEditingController(text: it.unitPrice.toString()), keyboardType: TextInputType.numberWithOptions(decimal: true), onChanged: (v){ it.unitPrice = double.tryParse(v) ?? 0; }, decoration: const InputDecoration(labelText: 'سعر الوحدة'))),
                  IconButton(icon: const Icon(Icons.delete_forever), onPressed: () => _removeRow(i)),
                ])
              ])));
            }),
            const SizedBox(height: 8),
            Align(alignment: Alignment.centerRight, child: TextButton.icon(onPressed: _addRow, icon: const Icon(Icons.add), label: const Text('إضافة سطر'))),
            const SizedBox(height: 12),
            Text('الإجمالي: ${total.toStringAsFixed(2)} ر.س', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(controller: _notes, decoration: const InputDecoration(labelText: 'ملاحظات')),
            const SizedBox(height: 18),
            Row(children: [Expanded(child: ElevatedButton(onPressed: _save, child: const Text('حفظ')))],)
          ]),
        ),
      ),
    );
  }
}
