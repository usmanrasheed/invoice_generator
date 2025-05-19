import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invoice/controllers/invoice_controller.dart';
import 'package:invoice/models/invoice_item.dart';
import 'package:invoice/res/colors/app_color.dart';
import 'package:invoice/services/pdf_generator.dart';
import 'package:printing/printing.dart';

class InvoiceScreen extends StatelessWidget {
  InvoiceScreen({super.key});

  final controller = Get.put(InvoiceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back button
        title: Text( 'INVOICE', style: TextStyle(color: AppColor.whiteColor),),
        backgroundColor: AppColor.primaryColor,
      ),

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //logo invoice number
              Row(
                children: [
                  //Logo
                  Expanded(
                    flex: 2, // 25%
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () async {
                            final picker = ImagePicker();
                            final picked = await picker.pickImage(source: ImageSource.gallery);
                            if (picked != null) {
                              controller.setLogo(await picked.readAsBytes(), picked.name);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primaryDarkColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ), // optional: control shadow
                          ),
                          child: Center(
                            child: Row(
                              children: [
                                Icon(Icons.camera_alt, color: Colors.white),
                                SizedBox(width: 5),
                                Obx(() => Text(
                                  controller.logoName.value.length >= 6
                                      ? controller.logoName.value.substring(0, 6)
                                      : controller.logoName.value,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //Invoice no
                  Expanded(
                    flex: 3, // 50%
                    child: Obx(
                          ()=> Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: controller.invoiceNoController.value,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 5, right: 5),
                                hintText: '0000',
                                labelText: 'Invoice No',
                                errorText: controller.invoiceNoError.value.isNotEmpty
                                    ? controller.invoiceNoError.value
                                    : null,
                                border: OutlineInputBorder(),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 10,right: 5),
                                  child: Icon(Icons.receipt, size: 20,color: AppColor.primaryDarkColor,),
                                ),
                                prefixIconConstraints: BoxConstraints(
                                  minWidth: 30,
                                  minHeight: 30,
                                ),
                              ),
                            ),
                          ),
                    ),
                  )
                ],
              ),
              //bill title
              Obx(
                ()=> Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: controller.billTitleController.value,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 5, right: 5),
                      hintText: 'Bill Title',
                      labelText: 'Bill Title',
                      errorText: controller.billTitleError.value.isNotEmpty
                          ? controller.billTitleError.value
                          : null,
                      border: OutlineInputBorder(),
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 10,right: 10),
                        child: Icon(Icons.edit, size: 20,color: AppColor.primaryDarkColor),
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 30,
                        minHeight: 30,
                      ),
                    ),
                  ),
                ),
              ),
              //bill date payment term
              Row(
                children: [
                  //date
                  Expanded(
                    child: Obx(
                      ()=> Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: controller.dateController.value,
                          readOnly: true, // Prevent keyboard
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              String formattedDate = "${pickedDate.day.toString().padLeft(2, '0')}-"
                                  "${pickedDate.month.toString().padLeft(2, '0')}-"
                                  "${pickedDate.year}";
                              controller.dateController.value.text = formattedDate;
                            }
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 5, right: 5),
                            hintText: '01-12-2001',
                            labelText: 'Bill Date',
                            errorText: controller.dateError.value.isNotEmpty
                                ? controller.dateError.value
                                : null,
                            border: OutlineInputBorder(),
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 10,right: 5),
                              child: Icon(Icons.calendar_month, size: 20,color: AppColor.primaryDarkColor),
                            ),
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 30,
                              minHeight: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //Payment term
                  Expanded(
                    child: Obx(
                      ()=> Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: controller.paymentTermController.value,
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: AppColor.primaryDarkColor),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left: 5, right: 5),
                            hintText: 'Terms(Optional)',
                            labelText: 'Payment Term(Optional)',
                            filled: true,
                            fillColor: AppColor.optionalFieldFillColor,
                            border: OutlineInputBorder(),
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 10, right: 5),
                              child: Icon(Icons.note_add, size: 20,color: AppColor.primaryDarkColor),
                            ),
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 30,
                              minHeight: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //due date po number
              Row(
                children: [
                  //due date
                  Expanded(
                    child: Obx(
                          ()=> Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: controller.dueDateController.value,
                              readOnly: true, // Prevent keyboard
                              onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              String formattedDate = "${pickedDate.day.toString().padLeft(2, '0')}-"
                                  "${pickedDate.month.toString().padLeft(2, '0')}-"
                                  "${pickedDate.year}";
                              controller.dueDateController.value.text = formattedDate;
                            }
                                                  },
                                                  decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left: 5, right: 5),
                            hintText: '01-12-2001',
                            labelText: 'Due Date(Optional)',
                            filled: true,
                            fillColor: AppColor.optionalFieldFillColor,
                            border: OutlineInputBorder(),
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 10,right: 5),
                              child: Icon(Icons.calendar_month, size: 20,color: AppColor.primaryDarkColor),
                            ),
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 30,
                              minHeight: 30,
                            ),
                                                  ),
                                                ),
                          ),
                    ),
                  ),
                  //po no
                  Expanded(
                    child: Obx(
                      ()=> Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: controller.poNumberController.value,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: AppColor.primaryDarkColor),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left: 5, right: 5),
                            hintText: '0000(Optional)',
                            labelText: 'PO Number(Optional)',
                            filled: true,
                            fillColor: AppColor.optionalFieldFillColor,
                            border: OutlineInputBorder(),
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 10,right: 5),
                              child: Icon(Icons.numbers, size: 20,color: AppColor.primaryDarkColor),
                            ),
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 30,
                              minHeight: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //bill to ship to
              Row(
                children: [
                  //bill to
                  Expanded(
                    child: Obx(
                          ()=>Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: controller.billToController.value,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 5, right: 5),
                            hintText: 'Bill to',
                            labelText: 'Bill to',
                            errorText: controller.billToError.value.isNotEmpty
                              ? controller.billToError.value
                              : null,
                            border: OutlineInputBorder(),
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 10, right: 5),
                              child: Icon(Icons.person_outline, size: 20,color: AppColor.primaryDarkColor),
                            ),
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 30,
                              minHeight: 30,
                            ),
                                                  ),
                                                ),
                          ),
                    ),
                  ),
                  //ship to
                  Expanded(
                    child: Obx(
                      ()=> Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: controller.shipToController.value,
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: AppColor.primaryDarkColor),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left: 5, right: 5),
                            hintText: 'Ship to(Optional)',
                            labelText: 'Ship to(Optional)',
                            filled: true,
                            fillColor: AppColor.optionalFieldFillColor,
                            border: OutlineInputBorder(),
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 10, right: 5),
                              child: Icon(Icons.location_on_outlined, size: 20,color: AppColor.primaryDarkColor),
                            ),
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 30,
                              minHeight: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Divider with text "TABLE ROW"
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.black, thickness: 1.0,)), // Left side divider
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'TABLE ROW',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.black, thickness: 1.0,)), // Right side divider
                ],
              ),
              //table content
              Obx(() => Column(
                children: controller.items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Column(children: [
                    //item description
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: item.item,
                        onChanged: (val) => controller.updateItem(index, InvoiceItem(item: val, quantity: item.quantity, rate: item.rate)),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 5, right: 5),
                          hintText: 'Description',
                          labelText: 'Item',
                          border: OutlineInputBorder(),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 10,right: 5),
                            child: Icon(Icons.description, size: 20,color: AppColor.primaryDarkColor),
                          ),
                          prefixIconConstraints: BoxConstraints(
                            minWidth: 30,
                            minHeight: 30,
                          ),
                        ),

                      ),
                    ),
                    //quantity rate and amount
                    Row(
                      children: [
                        //qty
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                //initialValue: item.quantity.toString(),
                                  onChanged: (val) => controller.updateItem(index, InvoiceItem(item: item.item, quantity: int.parse(val), rate: item.rate)),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 5, right: 5),
                                hintText: '00',
                                labelText: 'Qty',
                                border: OutlineInputBorder(),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 5,right: 2),
                                  child: Icon(Icons.numbers, size: 20,color: AppColor.primaryDarkColor),
                                ),
                                prefixIconConstraints: BoxConstraints(
                                  minWidth: 30,
                                  minHeight: 30,
                                ),
                              )
                                                    ),
                            )),
                        //rates
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                                      //initialValue: item.rate.toString(),
                                                      onChanged: (val) => controller.updateItem(index, InvoiceItem(item: item.item, quantity: item.quantity, rate: double.parse(val))),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 5, right: 5),
                                hintText: '00',
                                labelText: 'Rates',
                                border: OutlineInputBorder(),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 5,right: 2),
                                  child: Icon(Icons.money, size: 20,color: AppColor.primaryDarkColor),
                                ),
                                prefixIconConstraints: BoxConstraints(
                                  minWidth: 30,
                                  minHeight: 30,
                                ),
                              )

                                                    ),
                            )),
                        //item amount
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 11),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColor.primaryDarkColor),
                                borderRadius: BorderRadius.circular(5),
                                color: AppColor.disableColor
                              ),
                              child: Obx(() => Row(
                                children: [
                                  Icon(Icons.money, size: 20,color: AppColor.whiteColor),
                                  SizedBox(width: 10),
                                  Text(
                                    controller.items[index].amount.toStringAsFixed(1),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize:16,fontWeight: FontWeight.bold, color: AppColor.whiteColor),
                                  ),
                                ],
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]);
                }).toList(),
              )),
              //Add New Row Button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: controller.addItem,
                    icon: Icon(
                      Icons.add, // Replace with your desired icon
                      color: Colors.white,
                    ),
                    label: Text(
                      'ADD New Item', // Replace with your text
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryDarkColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                  ),
                ),
              ),
              // Divider with text "End TABLE ROW"
              Divider(color: Colors.black, thickness: 1.0,),
              //sub total
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'SUB TOTAL : ',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryDarkColor
                        ),
                      ),
                    ),
                  ),// Minor spacing between fields
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 11),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.primaryDarkColor),
                          borderRadius: BorderRadius.circular(5),
                          color: AppColor.disableColor
                        ),
                        child: Obx(() => Row(
                          children: [
                            Icon(Icons.money, size: 20,color: AppColor.whiteColor),
                            SizedBox(width: 10),
                            Text(
                              controller.subTotal.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: AppColor.whiteColor),
                            ),
                          ],
                        )),
                      ),
                    ),
                  ),
                ],
              ),
              //discount
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final parsed = double.tryParse(value) ?? 0.0;
                    controller.discount.value = parsed;
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10, right: 5),
                    hintText: 'Discount(Optional)',
                    labelText: 'Discount(Optional)',
                    filled: true,
                    fillColor: AppColor.optionalFieldFillColor,
                    border: OutlineInputBorder(),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(Icons.percent, size: 20, color: AppColor.primaryDarkColor,),
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 30,
                      minHeight: 30,
                    ),
                  ),
                ),
              ),
              //tax and shipping
              Row(
                children: [
                  //tax
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final parsed = double.tryParse(value) ?? 0.0;
                          controller.tax.value = parsed;
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10),
                          hintText: 'Tax(Optional)',
                          labelText: 'Tax(Optional)',
                          filled: true,
                          fillColor: AppColor.optionalFieldFillColor,
                          border: OutlineInputBorder(),
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.percent, size: 20,color: AppColor.primaryDarkColor,),
                          ),
                          prefixIconConstraints: BoxConstraints(
                            minWidth: 30,
                            minHeight: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                  //shipping
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final parsed = double.tryParse(value) ?? 0.0;
                          controller.shipping.value = parsed;
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 5, right: 5),
                          hintText: 'Shipping(Optional)',
                          labelText: 'Shipping(Optional)',
                          filled: true,
                          fillColor: AppColor.optionalFieldFillColor,
                          border: OutlineInputBorder(),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 10, right: 5),
                            child: Icon(Icons.money_sharp, size: 20, color: AppColor.primaryDarkColor,),
                          ),
                          prefixIconConstraints: BoxConstraints(
                            minWidth: 30,
                            minHeight: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //total
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'TOTAL : ',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryDarkColor
                        ),
                      ),
                    ),
                  ),// Minor spacing between fields
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 11),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.primaryDarkColor),
                          borderRadius: BorderRadius.circular(5),
                          color: AppColor.disableColor
                        ),
                        child: Obx(() => Row(
                          children: [
                            Icon(Icons.money, size: 20,color: AppColor.whiteColor),
                            SizedBox(width: 10),
                            Text(
                              controller.totalAmount.toString(),
                              textAlign: TextAlign.center ,
                              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold, color: AppColor.whiteColor),
                            ),
                          ],
                        )),
                      ),
                    ),
                  ),
                ],
              ),
              //amount paid
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final parsed = double.tryParse(value) ?? 0.0;
                    controller.amountPaid.value = parsed;
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 5, right: 5),
                    hintText: 'Amount Paid',
                    labelText: 'Amount Paid',
                    border: OutlineInputBorder(),
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 10, right: 5),
                      child: Icon(Icons.money, size: 20, color: AppColor.primaryDarkColor,),
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 30,
                      minHeight: 30,
                    ),
                  ),
                ),
              ),
              //balance due
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'BALANCE DUE : ',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryDarkColor
                        ),
                      ),
                    ),
                  ),// Minor spacing between fields
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 11),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.primaryDarkColor),
                          borderRadius: BorderRadius.circular(5),
                          color: AppColor.disableColor
                        ),
                        child: Obx(() => Row(
                          children: [
                            Icon(Icons.money, size: 20,color: AppColor.whiteColor),
                            SizedBox(width: 10,),
                            Text(
                              controller.balanceDue.toString(),
                              textAlign: TextAlign.center ,
                              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold, color: AppColor.whiteColor),
                            ),
                          ],
                        )),
                      ),
                    ),
                  ),
                ],
              ),
              //Notes
              Obx(
                ()=> Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: controller.notesController.value,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 5, right: 5),
                      hintText: 'Notes(Optional)',
                      labelText: 'Notes(Optional)',
                      filled: true,
                      fillColor: AppColor.optionalFieldFillColor,
                      border: OutlineInputBorder(),
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 10,right: 10),
                        child: Icon(Icons.notes, size: 20,color: AppColor.primaryDarkColor,),
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 30,
                        minHeight: 30,
                      ),
                    ),
                  ),
                ),
              ),
              //terms
              Obx(
                ()=> Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: controller.termsController.value,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 5, right: 5),
                      hintText: 'Terms(Optional)',
                      labelText: 'Terms(Optional)',
                      filled: true,
                      fillColor: AppColor.optionalFieldFillColor,
                      border: OutlineInputBorder(),
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 10,right: 10),
                        child: Icon(Icons.notes, size: 20,color: AppColor.primaryDarkColor),
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 30,
                        minHeight: 30,
                      ),
                    ),
                  ),
                ),
              ),
              //pdf generate button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      controller.validateAllTextField();
                      if(controller.isFormValid()){
                        await Printing.layoutPdf(
                          onLayout: (format) => generateInvoicePDF(controller, format),
                        );
                      }
                    },
                    icon: Icon(
                      Icons.picture_as_pdf, // Replace with your desired icon
                      color: Colors.white,
                    ),
                    label: Text(
                      'Generate Invoice', // Replace with your text
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryDarkColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
