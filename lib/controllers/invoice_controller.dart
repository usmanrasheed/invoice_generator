import 'dart:typed_data';
import 'package:get/get.dart';
import '../models/invoice_item.dart';

class InvoiceController extends GetxController {
  // Text fields
  var invoiceNo = ''.obs;
  var billType = ''.obs;
  var billTo = ''.obs;
  var shipTo = ''.obs;
  var date = ''.obs;
  var paymentTerms = ''.obs;
  var dueDate = ''.obs;
  var poNumber = ''.obs;

  var notes = ''.obs;
  var terms = ''.obs;
  var discount = 0.0.obs;
  var tax = 0.0.obs;
  var shipping = 0.0.obs;
  var amountPaid = 0.0.obs;

  var logoBytes = Rxn<Uint8List>();

  var items = <InvoiceItem>[InvoiceItem()].obs;

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.amount);
  double get total => subtotal * (1 + tax.value / 100) - (subtotal * discount.value / 100) + shipping.value;
  double get balanceDue => total - amountPaid.value;

  void addItem() {
    items.add(InvoiceItem());
  }

  void removeItem(int index) {
    items.removeAt(index);
  }

  void updateItem(int index, InvoiceItem item) {
    items[index] = item;
  }

  void setLogo(Uint8List bytes) {
    logoBytes.value = bytes;
  }
}
