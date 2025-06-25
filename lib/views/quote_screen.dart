import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invoice/res/widgets/text_field_widget.dart';

import '../controllers/invoice_controller.dart';
import '../res/colors/app_color.dart';

class QuoteScreen extends StatelessWidget {
  QuoteScreen({super.key});
  final controller = Get.put(InvoiceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.backgroundColor,
        appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back button
        title: Text( 'Quote'.tr, style: TextStyle(color: AppColor.whiteColor),),
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
                          ()=>TextFieldWidget(
                            controller: controller.invoiceNoController.value,
                            keyboardType: TextInputType.number,
                            hintText: '0000',
                            labelText: 'Invoice No',
                            prefixIcon: Icons.receipt,
                            errorText: controller.invoiceNoError.value.isNotEmpty
                                ? controller.invoiceNoError.value
                                : null,
                          ),

                    ),
                  )
                ],
              ),
              //bill title
/*
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
*/

            ],
          ),
        ),
      ),

    );
  }
}
