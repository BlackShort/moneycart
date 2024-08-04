import 'package:flutter/material.dart';

class Processing extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? message;

  const Processing({
    super.key,
    this.title = 'Processing',
    this.subTitle = 'Working on it',
    this.message = 'Your request is under process, we will update you soon.',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title!,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: Navigator.of(context).canPop(),
        backgroundColor: const Color(0xFF56c596),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/processing.png',
                width: MediaQuery.of(context).size.width * 1,
              ), // Add an image in your assets
              const SizedBox(height: 20),
              Text(
                subTitle!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                message!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}