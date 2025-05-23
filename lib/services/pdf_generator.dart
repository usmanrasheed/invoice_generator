import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../controllers/invoice_controller.dart';
import '../models/invoice_item.dart';

Future<Uint8List> generateInvoicePDF(InvoiceController controller, PdfPageFormat format) async {
  final pdf = pw.Document();
/*
  final isLandscape = format.width > format.height;
  final headerStyle = pw.TextStyle(fontSize: isLandscape ? 26 : 22, fontWeight: pw.FontWeight.bold);
  final labelStyle = pw.TextStyle(fontSize: isLandscape ? 12 : 10);
*/

  // Helper for optional sections
  pw.Widget? buildLabeledText(String label, String value) {
    if (value.trim().isEmpty) return null;
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text("$label:"),
        pw.SizedBox(height: 8),
        pw.Text(value, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  pdf.addPage(
    pw.MultiPage(
      pageFormat: format,
      margin: pw.EdgeInsets.all(32),
      build: (context) => [
        // Top Header
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            // FIRST COLUMN
            pw.Expanded(
              flex: 1,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (controller.logoBytes.value != null) ...[
                    pw.ClipRRect(
                      horizontalRadius: 5,
                      verticalRadius: 5,
                      child: pw.Image(
                        pw.MemoryImage(controller.logoBytes.value!),
                        height: 100,
                      ),
                    ),
                    pw.SizedBox(height: 18),
                  ],
                  pw.Text(controller.billTitleController.value.text, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 25),
                  pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("Bill To:"),
                            pw.SizedBox(height: 8),
                            pw.Text(controller.billToController.value.text, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                      ),
                      pw.SizedBox(width: 20),
                      if (controller.shipToController.value.text.trim().isNotEmpty)
                        pw.Expanded(
                          child: buildLabeledText("Ship To", controller.shipToController.value.text)!,
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // SECOND COLUMN
            pw.Expanded(
              flex: 1,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text("INVOICE", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  pw.Text("#  ${controller.invoiceNoController.value.text}"),
                  pw.SizedBox(height: 45),
                  pw.Row(
                    children: [
                      pw.Expanded(
                        flex: 2,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(top: 8),
                              child: pw.Text("Date:"),
                            ),
                            if (controller.paymentTermController.value.text.trim().isNotEmpty)
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(top: 8),
                                child: pw.Text("Payment Terms:"),
                              ),
                            if (controller.dueDateController.value.text.trim().isNotEmpty)
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(top: 8),
                                child: pw.Text("Due Date:"),
                              ),
                            if (controller.poNumberController.value.text.trim().isNotEmpty)
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(top: 8),
                                child: pw.Text("PO Number:"),
                              ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(top: 8),
                              child: pw.Text("Balance Due:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(width: 20),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(top: 8),
                              child: pw.Text(controller.dateController.value.text),
                            ),
                            if (controller.paymentTermController.value.text.trim().isNotEmpty)
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(top: 8),
                                child: pw.Text(controller.paymentTermController.value.text),
                              ),
                            if (controller.dueDateController.value.text.trim().isNotEmpty)
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(top: 8),
                                child: pw.Text(controller.dueDateController.value.text),
                              ),
                            if (controller.poNumberController.value.text.trim().isNotEmpty)
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(top: 8),
                                child: pw.Text(controller.poNumberController.value.text),
                              ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(top: 8),
                              child: pw.Text(controller.balanceDue.toStringAsFixed(2), style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ),
                          ],

                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        pw.SizedBox(height: 35),

        // ITEMS TABLE
        pw.Table(
          columnWidths: {
            0: pw.FlexColumnWidth(3),
            1: pw.FlexColumnWidth(1),
            2: pw.FlexColumnWidth(1),
            3: pw.FlexColumnWidth(1),
          },
          border: pw.TableBorder(
            top: pw.BorderSide.none,
            bottom: pw.BorderSide.none,
            left: pw.BorderSide.none,
            right: pw.BorderSide.none,
            horizontalInside: pw.BorderSide.none,
            verticalInside: pw.BorderSide.none,
          ),
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#000000'),
                borderRadius: pw.BorderRadius.only(
                  topLeft: pw.Radius.circular(6),
                  topRight: pw.Radius.circular(6),
                  bottomRight: pw.Radius.circular(6),
                  bottomLeft: pw.Radius.circular(6),
                ),
              ),
              children: [
                pw.Padding(
                  padding: pw.EdgeInsets.all(8),
                  child: pw.Text('Item', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.all(8),
                  child: pw.Text('Quantity', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.all(8),
                  child: pw.Text('Rate', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.all(8),
                  child: pw.Text('Amount', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
                ),
              ],
            ),
            ...controller.items.map((item) {
              return pw.TableRow(
                children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text(item.item),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text(item.quantity.toString()),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text(item.rate.toStringAsFixed(2)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text(item.amount.toStringAsFixed(2)),
                  ),
                ],
              );
            }).toList(),
          ],
        ),

        pw.SizedBox(height: 25),

        // FINANCIAL SUMMARY
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Spacer(flex: 5),
            pw.Expanded(
              flex: 4,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 8),
                    child: pw.Text("Subtotal: "),
                  ),
                  if (controller.discount.value > 0)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 8),
                      child: pw.Text("Discount (${controller.discount}%): "),
                    ),
                  if (controller.tax.value > 0)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 8),
                      child: pw.Text("Tax (${controller.tax}%): "),
                    ),
                  if (controller.shipping.value > 0)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 8),
                      child: pw.Text("Shipping: "),
                    ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 8),
                    child: pw.Text("Total: "),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 8),
                    child: pw.Text("Amount Paid: "),
                  ),
                ],

              ),
            ),
            pw.Expanded(
              flex: 2,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 8),
                    child: pw.Text(controller.subTotal.toStringAsFixed(2)),
                  ),
                  if (controller.discount.value > 0)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 8),
                      child: pw.Text((controller.subTotal * controller.discount.value / 100).toStringAsFixed(2)),
                    ),
                  if (controller.tax.value > 0)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 8),
                      child: pw.Text((controller.subTotal * controller.tax.value / 100).toStringAsFixed(2)),
                    ),
                  if (controller.shipping.value > 0)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 8),
                      child: pw.Text(controller.shipping.value.toStringAsFixed(2)),
                    ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 8),
                    child: pw.Text(controller.totalAmount.toStringAsFixed(2)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 8),
                    child: pw.Text(controller.amountPaid.value.toStringAsFixed(2)),
                  ),
                ],
              ),

            ),
          ],
        ),

        pw.SizedBox(height: 24),

        // NOTES AND TERMS
        pw.Row(
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (controller.notesController.value.text.trim().isNotEmpty) ...[
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 2),
                      child: pw.Text("Notes:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 3),
                      child: pw.Text(controller.notesController.value.text),
                    ),
                  ],
                  if (controller.termsController.value.text.trim().isNotEmpty) ...[
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 10),
                      child: pw.Text("Terms:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 3),
                      child: pw.Text(controller.termsController.value.text),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );

  return pdf.save();
}


/*
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../controllers/invoice_controller.dart';
import '../models/invoice_item.dart';

Future<Uint8List> generateInvoicePDF(InvoiceController controller, PdfPageFormat format) async {
  final pdf = pw.Document();
  final isLandscape = format.width > format.height;

  final headerStyle = pw.TextStyle(fontSize: isLandscape ? 26 : 22, fontWeight: pw.FontWeight.bold);
  final labelStyle = pw.TextStyle(fontSize: isLandscape ? 12 : 10);

  pdf.addPage(
    pw.MultiPage(
      pageFormat: format,
      margin: pw.EdgeInsets.all(32),
      build: (context) => [
        // Top Header Row
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // FIRST COLUMN: Logo + Bill Info
            pw.Expanded(
              flex: 1,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (controller.logoBytes.value != null) ...[
                    pw.Image(pw.MemoryImage(controller.logoBytes.value!), height: 100),
                    pw.SizedBox(height: 15),
                  ],
                  pw.Text("  ${controller.billTitleController.value.text}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 12),
                  pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("Bill To:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.Text(controller.billToController.value.text),
                          ],
                        ),
                      ),
                      pw.SizedBox(width: 20),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("Ship To:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.Text(controller.shipToController.value.text),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // SECOND COLUMN: Invoice Info
            pw.Expanded(
              flex: 1,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text("INVOICE", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  pw.Text("#  ${controller.invoiceNoController.value.text}"),
                  pw.SizedBox(height: 15),
                  pw.Row(
                    children: [
                      pw.Expanded(
                        flex: 2,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text("Date: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 5),
                            pw.Text("Payment Terms: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 5),
                            pw.Text("Due Date: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 5),
                            pw.Text("PO Number: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 5),
                            pw.Text("Balance Due: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                      ),
                      pw.SizedBox(width: 20),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text(controller.dateController.value.text),
                            pw.SizedBox(height: 5),
                            pw.Text(controller.paymentTermController.value.text),
                            pw.SizedBox(height: 5),
                            pw.Text(controller.dueDateController.value.text),
                            pw.SizedBox(height: 5),
                            pw.Text(controller.poNumberController.value.text),
                            pw.SizedBox(height: 5),
                            pw.Text(controller.balanceDue.toStringAsFixed(2)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),


        pw.SizedBox(height: 24),

        // Items Table
        pw.Table(
          columnWidths: {
            0: pw.FlexColumnWidth(3), // Item
            1: pw.FlexColumnWidth(1), // Quantity
            2: pw.FlexColumnWidth(1), // Rate
            3: pw.FlexColumnWidth(1), // Amount
          },
          border: pw.TableBorder(
            top: pw.BorderSide.none,
            bottom: pw.BorderSide.none,
            left: pw.BorderSide.none,
            right: pw.BorderSide.none,
            horizontalInside: pw.BorderSide.none,
            verticalInside: pw.BorderSide.none,
          ),
          children: [
            // Header Row
            pw.TableRow(
              decoration: pw.BoxDecoration(
                  color: PdfColors.black,
                  borderRadius: pw.BorderRadius.only(
                    topLeft: pw.Radius.circular(6),
                    topRight: pw.Radius.circular(6),// Top-left corner
                    bottomLeft:pw.Radius.circular(6),
                    bottomRight: pw.Radius.circular(6),
                  ),
              ),

              children: [
                pw.Padding(
                  padding: pw.EdgeInsets.only(left: 18,right: 8,top: 8,bottom: 8),
                  child: pw.Text('Item', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.all(8),
                  child: pw.Text('Quantity', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.all(8),
                  child: pw.Text('Rate', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.all(8),
                  child: pw.Text('Amount', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
                ),
              ],
            ),
            // Data Rows
            ...controller.items.map((item) {
              return pw.TableRow(
                children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text(item.item),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text(item.quantity.toString()),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text(item.rate.toStringAsFixed(2)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text(item.amount.toStringAsFixed(2)),
                  ),
                ],
              );
            }).toList(),
          ],
        ),

        pw.SizedBox(height: 24),

        // Financial Summary
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Spacer(flex: 5),
            pw.Expanded(
                flex: 4,
                child:pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text("Subtotal: "),
                    pw.Text("Discount (${controller.discount}%): "),
                    pw.Text("Tax (${controller.tax}%): "),
                    pw.Text("Shipping: "),
                    pw.Text("Total: "),
                    pw.Text("Amount Paid: "),
                  ],
                )
            ),

            pw.Expanded(
              flex: 2,
              child:pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(controller.subTotal.toStringAsFixed(2)),
                  pw.Text((controller.subTotal * controller.discount.value / 100).toStringAsFixed(2)),
                  pw.Text((controller.subTotal * controller.tax.value / 100).toStringAsFixed(2)),
                  pw.Text(controller.shipping.value.toStringAsFixed(2)),
                  pw.Text(controller.totalAmount.toStringAsFixed(2)),
                  pw.Text(controller.amountPaid.value.toStringAsFixed(2)),
                ],
              ),
            )
          ],
        ),

        pw.SizedBox(height: 24),

        // Notes and Terms
        pw.Row(
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Notes:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(controller.notesController.value.text),
                  pw.SizedBox(height: 10),
                  pw.Text("Terms:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(controller.termsController.value.text),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );

  return pdf.save();
}
*/
