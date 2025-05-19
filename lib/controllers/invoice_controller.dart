import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/invoice_item.dart';
import '../res/utils/utils.dart';

class InvoiceController extends GetxController {
  var logoBytes = Rxn<Uint8List>();
  var logoName = 'LOGO'.obs;
  var items = <InvoiceItem>[InvoiceItem()].obs;
  var discount = 0.0.obs;
  var tax = 0.0.obs;
  var shipping = 0.0.obs;
  var amountPaid = 0.0.obs;

  final invoiceNoController = TextEditingController().obs;
  final billTitleController = TextEditingController().obs;
  final dateController = TextEditingController().obs;
  final billToController = TextEditingController().obs;
  final paymentTermController = TextEditingController().obs;
  final dueDateController = TextEditingController().obs;
  final poNumberController = TextEditingController().obs;
  final shipToController = TextEditingController().obs;
  final notesController = TextEditingController().obs;
  final termsController = TextEditingController().obs;

  var invoiceNoError = ''.obs;
  var billTitleError = ''.obs;
  var dateError = ''.obs;
  var billToError = ''.obs;
/*  var itemError = ''.obs;
  var qtyError = ''.obs;
  var ratesError = ''.obs;*/


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


  void invoiceNo() {
    if (invoiceNoController.value.text.isEmpty) {
      invoiceNoError.value = "Required".tr;
    }else {
      invoiceNoError.value = '';
    }
  }
  void billTitle() {
    if (billTitleController.value.text.isEmpty) {
      billTitleError.value = "Required".tr;
    }else {
      billTitleError.value = '';
    }
  }
  void date() {
    if (dateController.value.text.isEmpty) {
      dateError.value = "Required".tr;
    }else {
      dateError.value = '';
    }
  }
  void billTo() {
    if (billToController.value.text.isEmpty) {
      billToError.value = "Required".tr;
    }else {
      billToError.value = '';
    }
  }

  void validateAllTextField() {
    invoiceNo();
    billTitle();
    date();
    billTo();
  }

  bool isFormValid() {
    return invoiceNoError.value.isEmpty &&
        billTitleError.value.isEmpty &&
        dateError .value.isEmpty &&
        billToError.value.isEmpty;
  }

  /*void invoiceGenerateFun(){
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

  }*/
  @override
  void onClose() {
    invoiceNoController.value.dispose();
    billTitleController.value.dispose();
    dateController.value.dispose();
    paymentTermController.value.dispose();
    dueDateController.value.dispose();
    poNumberController.value.dispose();
    billToController.value.dispose();
    shipToController.value.dispose();
    notesController.value.dispose();
    termsController.value.dispose();

    super.onClose();
  }
}
