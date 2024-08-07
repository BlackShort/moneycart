import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneycart/config/theme/app_pallete.dart';
import 'package:moneycart/app/common/widgets/primary_button.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _complaintController = TextEditingController();
  String? _selectedSubject;

  final List<String> _subjects = [
    'Service Quality',
    'Driver Behavior',
    'Ride Experience',
    'Payment Issues',
    'Others'
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Complaints',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 18,
              fontFamily: 'Poppins',
            ),
          ),
          titleSpacing: 0,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 19,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedSubject,
                    items: _subjects
                        .map((subject) => DropdownMenuItem(
                              value: subject,
                              child: Text(subject),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSubject = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Subject',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _complaintController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      labelText: 'Describe your complaint',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 15.0),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    text: 'Submit Complaint',
                    onPressed: () {
                      final complaint = _complaintController.text;
                      if (_selectedSubject == null) {
                        Get.snackbar('Error', 'Please select a subject.');
                      } else if (complaint.isNotEmpty) {
                        // Submit the complaint to the backend or API
                        Get.snackbar('Complaint Submitted',
                            'Thank you for your feedback.');
                        _complaintController.clear();
                        setState(() {
                          _selectedSubject = null;
                        });
                      } else {
                        Get.snackbar('Error', 'Please enter a complaint.');
                      }
                    },
                    color: AppPallete.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
