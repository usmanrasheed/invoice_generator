class InvoiceItem {
  String item;
  int quantity;
  double rate;

  InvoiceItem({this.item = '', this.quantity = 1, this.rate = 0.0});

  double get amount => quantity * rate;
}