import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/invoice_item.dart';

class InvoiceController extends GetxController {
  var logoBytes = Rxn<Uint8List>();
  var logoName = 'LOGO'.obs;
  //var invoiceNo = ''.obs;
  //var billTitle = ''.obs;
  //var date = ''.obs;
  //var paymentTerm = ''.obs;
  //var dueDate = ''.obs;
  //var poNumber = ''.obs;
  //var billTo = ''.obs;
  //var shipTo = ''.obs;
  var items = <InvoiceItem>[InvoiceItem()].obs;
  //var notes = ''.obs;
  //var terms = ''.obs;
  var discount = 0.0.obs;
  var tax = 0.0.obs;
  var shipping = 0.0.obs;
  var amountPaid = 0.0.obs;

  final invoiceNoController = TextEditingController().obs;
  final billTitleController = TextEditingController().obs;
  final dateController = TextEditingController().obs;
  final paymentTermController = TextEditingController().obs;
  final dueDateController = TextEditingController().obs;
  final poNumberController = TextEditingController().obs;
  final billToController = TextEditingController().obs;
  final shipToController = TextEditingController().obs;
  final notesController = TextEditingController().obs;
  final termsController = TextEditingController().obs;

  double get subTotal => items.fold(0.0, (sum, item) => sum + item.amount);
  double get totalAmount => subTotal * (1 + tax.value / 100) - (subTotal * discount.value / 100) + shipping.value;
  double get balanceDue => totalAmount - amountPaid.value;

  void addItem() {
    items.add(InvoiceItem());
  }

  void updateItem(int index, InvoiceItem item) {
    items[index] = item;
  }

  void removeItem(int index) {
    items.removeAt(index);
  }

  void setLogo(Uint8List bytes, String name) {
    logoBytes.value = bytes;
    logoName.value = name;
  }
}
