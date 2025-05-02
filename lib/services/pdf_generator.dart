import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../controllers/invoice_controller.dart';
import '../models/invoice_item.dart';

Future<Uint8List> generateInvoicePDF(InvoiceController controller) async {
  final pdf = pw.Document();

  pdf.addPage(pw.MultiPage(
    build: (context) => [
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (controller.logoBytes.value != null)
            pw.Image(pw.MemoryImage(controller.logoBytes.value!), height: 80),
          pw.Spacer(),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text("INVOICE", style: pw.TextStyle(fontSize: 24)),
              pw.Text("Invoice No: ${controller.invoiceNo}"),
              pw.SizedBox(height: 8),
              pw.Text("Date: ${controller.date}"),
              pw.Text("Payment Terms: ${controller.paymentTerms}"),
              pw.Text("Due Date: ${controller.dueDate}"),
              pw.Text("PO Number: ${controller.poNumber}"),
            ],
          ),
        ],
      ),
      pw.SizedBox(height: 20),
      pw.Row(
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Bill Type: ${controller.billType}"),
                pw.Text("Bill To:\n${controller.billTo}"),
              ],
            ),
          ),
          pw.Expanded(
            child: pw.Text("Ship To:\n${controller.shipTo}"),
          ),
        ],
      ),
      pw.SizedBox(height: 20),
      pw.Table.fromTextArray(
        headers: ["Item", "Quantity", "Rate", "Amount"],
        data: controller.items
            .map((item) => [
          item.item,
          item.quantity.toString(),
          item.rate.toStringAsFixed(2),
          item.amount.toStringAsFixed(2),
        ])
            .toList(),
      ),
      pw.SizedBox(height: 20),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Subtotal: ${controller.subtotal.toStringAsFixed(2)}"),
              pw.Text("Discount (${controller.discount}%): -${(controller.subtotal * controller.discount.value / 100).toStringAsFixed(2)}"),
              pw.Text("Tax (${controller.tax}%): +${(controller.subtotal * controller.tax.value / 100).toStringAsFixed(2)}"),
              pw.Text("Shipping: +${controller.shipping.toStringAsFixed(2)}"),
              pw.Divider(),
              pw.Text("Total: ${controller.total.toStringAsFixed(2)}"),
              pw.Text("Amount Paid: ${controller.amountPaid.toStringAsFixed(2)}"),
              pw.Text("Balance Due: ${controller.balanceDue.toStringAsFixed(2)}"),
            ],
          ),
        ],
      ),
      pw.SizedBox(height: 20),
      pw.Row(
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Notes:"),
                pw.Text(controller.notes.value),
                pw.SizedBox(height: 10),
                pw.Text("Terms:"),
                pw.Text(controller.terms.value),
              ],
            ),
          ),
        ],
      )
    ],
  ));

  return pdf.save();
}
