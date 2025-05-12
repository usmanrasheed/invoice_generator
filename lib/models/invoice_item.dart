class InvoiceItem {
  String item;
  int quantity;
  double rate;

  InvoiceItem({this.item = '', this.quantity = 0, this.rate = 0});

  double get amount => quantity * rate;

  @override
  String toString() {
    return 'Item: $item, Qty: $quantity, Rate: $rate, Amount: $amount';
  }
}