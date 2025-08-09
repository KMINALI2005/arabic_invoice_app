class InvoiceItem {
  String description;
  double qty;
  double unitPrice;

  InvoiceItem({required this.description, required this.qty, required this.unitPrice});

  Map<String, dynamic> toJson() => {
    'description': description,
    'qty': qty,
    'unitPrice': unitPrice,
  };

  factory InvoiceItem.fromJson(Map<String, dynamic> j) => InvoiceItem(
    description: j['description'] ?? '',
    qty: (j['qty'] ?? 0).toDouble(),
    unitPrice: (j['unitPrice'] ?? 0).toDouble(),
  );
}

class Invoice {
  String customer;
  String date; // formatted
  List<InvoiceItem> items;
  String notes;

  Invoice({required this.customer, required this.date, required this.items, this.notes = ''});

  double get total => items.fold(0, (s, it) => s + it.qty * it.unitPrice);

  Map<String, dynamic> toJson() => {
    'customer': customer,
    'date': date,
    'items': items.map((e) => e.toJson()).toList(),
    'notes': notes,
    'total': total,
  };

  factory Invoice.fromJson(Map<String, dynamic> j) => Invoice(
    customer: j['customer'] ?? '',
    date: j['date'] ?? '',
    items: (j['items'] as List<dynamic>? ?? []).map((e) => InvoiceItem.fromJson(e as Map<String, dynamic>)).toList(),
    notes: j['notes'] ?? '',
  );
}
