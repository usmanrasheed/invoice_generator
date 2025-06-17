import 'package:flutter/material.dart';

class SelectTemplateSheet extends StatelessWidget {
  const SelectTemplateSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: const BoxDecoration(
        color: Color(0xFFfafdff),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Select Invoice Template",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff263474),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _templateOption(
                context,
                imagePath: 'assets/templates/template1.png',
                onTap: () {
                  Navigator.pop(context); // Close popup
                  // TODO: Use Template 1
                },
              ),
              const SizedBox(width: 16),
              _templateOption(
                context,
                imagePath: 'assets/templates/template2.png',
                onTap: () {
                  Navigator.pop(context); // Close popup
                  // TODO: Use Template 2
                },
              ),
            ],
          ),
          Row(
            children: [
              _templateOption(
                context,
                imagePath: 'assets/templates/template1.png',
                onTap: () {
                  Navigator.pop(context); // Close popup
                  // TODO: Use Template 1
                },
              ),
              const SizedBox(width: 16),
              _templateOption(
                context,
                imagePath: 'assets/templates/template2.png',
                onTap: () {
                  Navigator.pop(context); // Close popup
                  // TODO: Use Template 2
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _templateOption(BuildContext context,
      {required String imagePath, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
