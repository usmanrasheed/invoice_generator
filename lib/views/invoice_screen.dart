import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invoice/controllers/invoice_controller.dart';
import 'package:invoice/models/invoice_item.dart';
import 'package:invoice/res/colors/app_color.dart';
import 'package:invoice/res/utils/utils.dart';

class InvoiceScreen extends StatelessWidget {
  InvoiceScreen({super.key});

  final controller = Get.put(InvoiceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back button
        title: Text( 'INVOICE', style: TextStyle(color: AppColor.whiteColor),),
        backgroundColor: AppColor.mainColor,
      ),

      body: Padding(
        padding: const EdgeInsets.only(left: 15.0,right: 15.0,top: 15.0,bottom: 40.0 ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: Get.height * 0.01),
              //Logo and invoice no
              Row(
                children: [
                  Expanded(
                    flex: 2, // 25%
                    child: InkWell(
                      onTap: () async {
                        final picker = ImagePicker();
                        final picked = await picker.pickImage(source: ImageSource.gallery);
                        if (picked != null) {
                          controller.setLogo(await picked.readAsBytes(),picked.name);
                        }
                      },
                      borderRadius: BorderRadius.circular(12.0),
                      child: Ink(
                        height: Get.height * 0.06,
                        decoration: BoxDecoration(
                          color: AppColor.secondaryColor,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.camera_alt, color: Colors.white, size: 20),
                              SizedBox(width: 5),
                              Obx(() => Text(
                                controller.logoName.value.length >= 8
                                    ? controller.logoName.value.substring(0, 8)
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
                  SizedBox(width: 12),
                  //Spacer(flex: 1),// Spacing between button and text
                  Expanded(
                    flex: 3, // 50%
                    child: Obx(
                          ()=> TextFormField(
                            controller: controller.invoiceNoController.value,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(left: 5, right: 5),
                              hintText: '0000',
                              labelText: 'Invoice No',
                              border: OutlineInputBorder(),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 10,right: 5),
                                child: Icon(Icons.receipt, size: 20),
                              ),
                              prefixIconConstraints: BoxConstraints(
                                minWidth: 30,
                                minHeight: 30,
                              ),
                            ),
                          ),
                    ),
                  )
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              //bill title
              Obx(
                ()=> TextFormField(
                  keyboardType: TextInputType.text,
                  controller: controller.billTitleController.value,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 5, right: 5),
                    hintText: 'Bill Title',
                    labelText: 'Bill Title',
                    border: OutlineInputBorder(),
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 10,right: 10),
                      child: Icon(Icons.edit, size: 20),
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 30,
                      minHeight: 30,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              //date and Payment term
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      ()=> TextFormField(
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
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 5, right: 5),
                          hintText: '01-12-2001',
                          labelText: 'Bill Date',
                          border: OutlineInputBorder(),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 10,right: 5),
                            child: Icon(Icons.calendar_month, size: 20),
                          ),
                          prefixIconConstraints: BoxConstraints(
                            minWidth: 30,
                            minHeight: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Minor spacing between fields
                  Expanded(
                    child: Obx(
                      ()=> TextFormField(
                        controller: controller.paymentTermController.value,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 5, right: 5),
                          hintText: 'terms(Optional)',
                          labelText: 'Payment Term(Optional)',
                          border: OutlineInputBorder(),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(Icons.note_add, size: 20),
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
              SizedBox(height: Get.height * 0.02),
              //due date and po no
              Row(
                children: [
                  Expanded(
                    child: Obx(
                          ()=> TextFormField(
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
                          labelText: 'Due Date',
                          border: OutlineInputBorder(),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 10,right: 5),
                            child: Icon(Icons.calendar_month, size: 20),
                          ),
                          prefixIconConstraints: BoxConstraints(
                            minWidth: 30,
                            minHeight: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Minor spacing between fields
                  Expanded(
                    child: Obx(
                      ()=> TextFormField(
                        controller: controller.poNumberController.value,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 5, right: 5),
                          hintText: '0000(Optional)',
                          labelText: 'PO Number(Optional)',
                          border: OutlineInputBorder(),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(Icons.numbers, size: 20),
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
              SizedBox(height: Get.height * 0.02),
              //bill to ship to
              Row(
                children: [
                  Expanded(
                    child: Obx(
                          ()=>TextFormField(
                            controller: controller.billToController.value,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 5, right: 5),
                          hintText: 'Bill to',
                          labelText: 'Bill to',
                          border: OutlineInputBorder(),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(Icons.person_outline, size: 20),
                          ),
                          prefixIconConstraints: BoxConstraints(
                            minWidth: 30,
                            minHeight: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Minor spacing between fields
                  Expanded(
                    child: Obx(
                      ()=> TextFormField(
                        controller: controller.shipToController.value,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 5, right: 5),
                          hintText: 'Ship to(Optional)',
                          labelText: 'Ship to(Optional)',
                          border: OutlineInputBorder(),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(Icons.location_on_outlined, size: 20),
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
              SizedBox(height: Get.height * 0.02),
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
                    //item
                    SizedBox(height: Get.height * 0.02),
                    TextFormField(
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
                          child: Icon(Icons.description, size: 20),
                        ),
                        prefixIconConstraints: BoxConstraints(
                          minWidth: 30,
                          minHeight: 30,
                        ),
                      ),

                    ),
                    SizedBox(height: Get.height * 0.02),
                    //quantity and amount
                    Row(
                      children: [
                        Expanded(child: TextFormField(
                          initialValue: item.quantity.toString(),
                          onChanged: (val) => controller.updateItem(index, InvoiceItem(item: item.item, quantity: int.parse(val), rate: item.rate)),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 5, right: 5),
                              hintText: '00',
                              labelText: 'Qty',
                              border: OutlineInputBorder(),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 10,right: 5),
                                child: Icon(Icons.numbers, size: 20),
                              ),
                              prefixIconConstraints: BoxConstraints(
                                minWidth: 30,
                                minHeight: 30,
                              ),
                            )
                        )),
                        SizedBox(width: 10), // Minor spacing between field
                        Expanded(child: TextFormField(
                          initialValue: item.rate.toString(),
                          onChanged: (val) => controller.updateItem(index, InvoiceItem(item: item.item, quantity: item.quantity, rate: double.parse(val))),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 5, right: 5),
                              hintText: '00',
                              labelText: 'Rates',
                              border: OutlineInputBorder(),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 10,right: 5),
                                child: Icon(Icons.money, size: 20),
                              ),
                              prefixIconConstraints: BoxConstraints(
                                minWidth: 30,
                                minHeight: 30,
                              ),
                            )

                        )),
                        SizedBox(width: 10), // Minor spacing between field
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 11),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Obx(() => Row(
                              children: [
                                Icon(Icons.money, size: 20),
                                SizedBox(width: 10),
                                Text(
                                  controller.items[index].amount.toStringAsFixed(2),
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            )),
                          ),
                        ),
                      ],
                    ),
                  ]);
                }).toList(),
              )),
              SizedBox(height: Get.height * 0.02),
              //ElevatedButton(onPressed: controller.addItem, child: Text("Add New Row")),
              ElevatedButton.icon(
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
                  backgroundColor: AppColor.secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
              // Divider with text "End TABLE ROW"
              Divider(color: Colors.black, thickness: 1.0,),
              SizedBox(height: Get.height * 0.02),
              //sub total
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'SUB TOTAL : ',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Minor spacing between fields
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 11),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Obx(() => Text(
                        controller.subTotal.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      )),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              //discount
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final parsed = double.tryParse(value) ?? 0.0;
                  controller.discount.value = parsed;
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10),
                  hintText: 'Discount(Optional)',
                  labelText: 'Discount(Optional)',
                  border: OutlineInputBorder(),
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.percent, size: 20),
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: 30,
                    minHeight: 30,
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              //tax and shipping
              Row(
                children: [
                  Expanded(
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
                        border: OutlineInputBorder(),
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(Icons.percent, size: 20),
                        ),
                        prefixIconConstraints: BoxConstraints(
                          minWidth: 30,
                          minHeight: 30,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Minor spacing between fields
                  Expanded(
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
                        border: OutlineInputBorder(),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(Icons.money_sharp, size: 20),
                        ),
                        prefixIconConstraints: BoxConstraints(
                          minWidth: 30,
                          minHeight: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              //total
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'TOTAL : ',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Minor spacing between fields
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 11),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Obx(() => Text(
                        controller.totalAmount.toString(),
                        textAlign: TextAlign.center ,
                        style: TextStyle(fontSize: 16),
                      )),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              //amount paid
              TextFormField(
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
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(Icons.money, size: 20),
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: 30,
                    minHeight: 30,
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              //balance due
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'BALANCE DUE : ',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Minor spacing between fields
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 11),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Obx(() => Text(
                        controller.balanceDue.toString(),
                        textAlign: TextAlign.center ,
                        style: TextStyle(fontSize: 16),
                      )),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              //Notes
              Obx(
                ()=> TextFormField(
                  controller: controller.notesController.value,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 5, right: 5),
                    hintText: 'Notes(Optional)',
                    labelText: 'Notes(Optional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 10,right: 10),
                      child: Icon(Icons.notes, size: 20),
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 30,
                      minHeight: 30,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              //terms
              Obx(
                ()=> TextFormField(
                  controller: controller.termsController.value,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 5, right: 5),
                    hintText: 'Terms(Optional)',
                    labelText: 'Terms(Optional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 10,right: 10),
                      child: Icon(Icons.notes, size: 20),
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 30,
                      minHeight: 30,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),

              ElevatedButton.icon(
                onPressed: (){
                  controller.invoiceGenerateFun();
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
                  backgroundColor: AppColor.secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
