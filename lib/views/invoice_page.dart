import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invoice/models/invoice_item.dart';
import '../controllers/invoice_controller.dart';
import '../services/pdf_generator.dart';
import 'package:printing/printing.dart';

class InvoicePage extends StatelessWidget {
  final controller = Get.put(InvoiceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Invoice Generator')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          ElevatedButton(
            onPressed: () async {
              final picker = ImagePicker();
              final picked = await picker.pickImage(source: ImageSource.gallery);
              if (picked != null) {
                controller.setLogo(await picked.readAsBytes());
              }
            },
            child: Text("Upload Logo"),
          ),
          TextField(onChanged: controller.invoiceNo, decoration: InputDecoration(labelText: 'Invoice No')),
          TextField(onChanged: controller.billType, decoration: InputDecoration(labelText: 'Bill Type')),
          // ... (More fields like Bill To, Ship To, Date etc.)

          Obx(() => Column(
            children: controller.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Row(children: [
                Expanded(child: TextFormField(
                  initialValue: item.item,
                  decoration: InputDecoration(labelText: "Item"),
                  onChanged: (val) => controller.updateItem(index, InvoiceItem(item: val, quantity: item.quantity, rate: item.rate)),
                )),
                Expanded(child: TextFormField(
                  initialValue: item.quantity.toString(),
                  decoration: InputDecoration(labelText: "Qty"),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => controller.updateItem(index, InvoiceItem(item: item.item, quantity: int.parse(val), rate: item.rate)),
                )),
                Expanded(child: TextFormField(
                  initialValue: item.rate.toString(),
                  decoration: InputDecoration(labelText: "Rate"),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => controller.updateItem(index, InvoiceItem(item: item.item, quantity: item.quantity, rate: double.parse(val))),
                )),
              ]);
            }).toList(),
          )),
          ElevatedButton(onPressed: controller.addItem, child: Text("Add New Row")),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final pdfData = await generateInvoicePDF(controller);
              await Printing.layoutPdf(onLayout: (_) => pdfData);
            },
            child: Text("Generate PDF"),
          )
        ]),
      ),
    );
  }
}
