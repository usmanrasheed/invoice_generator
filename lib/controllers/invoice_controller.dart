import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/invoice_item.dart';
import '../res/utils/utils.dart';

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
  //double get totalAmount => subTotal * (1 + tax.value / 100) - (subTotal * discount.value / 100) + shipping.value;
  double get totalAmount =>
      double.parse((subTotal * (1 + tax.value / 100) - (subTotal * discount.value / 100) + shipping.value).toStringAsFixed(2));
  //double get balanceDue => totalAmount - amountPaid.value;
  double get balanceDue => double.parse((totalAmount - amountPaid.value).toStringAsFixed(2));

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

  void invoiceGenerateFun(){
    String toastMessage =
        "logo title ${logoName.value}"
        "\nin no ${invoiceNoController.value.text}"
        "\ntitle ${billTitleController.value.text}"
        "\ndate ${dateController.value.text}"
        "${paymentTermController.value.text.isNotEmpty ? "\npay terms ${paymentTermController.value.text}" : ""}"
        "${dueDateController.value.text.isNotEmpty ? "\ndue date ${dueDateController.value.text}" : ""}"
        "${poNumberController.value.text.isNotEmpty ? "\npo no ${poNumberController.value.text}" : ""}"
        "\nbill to ${billToController.value.text}"
        "${shipToController.value.text.isNotEmpty ? "\nship to ${shipToController.value.text}" : ""}"
        "\n${items.map((item) => item.toString()).join('\n')}"
        "\nsub total $subTotal"
        "${discount.value != 0.0 ? "\ndiscount ${discount.value}" : ""}"
        "${tax.value != 0.0 ? "\ntax ${tax.value}" : ""}"
        "${shipping.value != 0.0 ? "\nshipping ${shipping.value}" : ""}"
        "\ntotal $totalAmount"
        "\npaid ${amountPaid.value}"
        "\nbalance due $balanceDue"
        "${notesController.value.text.isNotEmpty ? "\nnotes ${notesController.value.text}" : ""}"
        "${termsController.value.text.isNotEmpty ? "\nterms ${termsController.value.text}" : ""}";

    Utils.toastMessage(toastMessage);

  }
}
