import 'dart:typed_data';
import 'package:get/get.dart';
import '../models/invoice_item.dart';

class InvoiceController extends GetxController {
  // Text fields
/*  var invoiceNo = ''.obs;
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

  var items = <InvoiceItem>[InvoiceItem()].obs;*/
  var logoBytes = Rxn<Uint8List>();
  var invoiceNo = ''.obs;
  var billTitle = ''.obs;
  var date = ''.obs;
  var paymentTerm = ''.obs;
  var dueDate = ''.obs;
  var poNumber = ''.obs;
  var billTo = ''.obs;
  var shipTo = ''.obs;
  var items = <InvoiceItem>[InvoiceItem()].obs;
  var discount = 0.0.obs;
  var tax = 0.0.obs;
  var shipping = 0.0.obs;
  var amountPaid = 0.0.obs;
  var balanceDue = ''.obs;
  var notes = ''.obs;
  var terms = ''.obs;

  double get subTotal => items.fold(0.0, (sum, item) => sum + item.amount);
  double get totalAmount => subTotal * (1 + tax.value / 100) - (subTotal * discount.value / 100) + shipping.value;
  double get balanceAmount => totalAmount - amountPaid.value;

  void addItem() {
    items.add(InvoiceItem());
  }

  void updateItem(int index, InvoiceItem item) {
    items[index] = item;
  }

  void removeItem(int index) {
    items.removeAt(index);
  }

  void setLogo(Uint8List bytes) {
    logoBytes.value = bytes;
  }
}
