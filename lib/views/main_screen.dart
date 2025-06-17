import 'package:flutter/material.dart';

import '../res/colors/app_color.dart';
import '../res/widgets/select_template_sheet.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
   /* return Scaffold(
        backgroundColor: AppColor.backgroundColor,
    );
  }
}*/
    return Scaffold(
      backgroundColor: AppColor.backgroundColor, // backgroundColor
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Image or Logo
                Image.asset(
                  'assets/images/quinvo.png', // Make sure this image exists
                  height: 180,
                ),
                const SizedBox(height: 24),

                // Welcome Text
                const Text(
                  "Welcome to Quinvo",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryDarkColor, // primaryDarkColor
                  ),
                ),
                const SizedBox(height: 48),

                // INVOICE Button
                _buildMainButton(
                  context,
                  icon: Icons.receipt_long,
                  label: "INVOICE",
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      builder: (context) => const SelectTemplateSheet(),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // QUOTE Button
                _buildMainButton(
                  context,
                  icon: Icons.request_quote,
                  label: "QUOTE",
                  onPressed: () {
                    // TODO: Navigate to Quote Page
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainButton(BuildContext context,
      {required IconData icon,
        required String label,
        required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 28,color: AppColor.primaryDarkColor,),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryColor, // primaryColor
          foregroundColor: AppColor.whiteColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}