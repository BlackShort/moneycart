import 'package:moneycart/app/common/widgets/primary_button.dart';
import 'package:moneycart/app/tds/controllers/tds_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moneycart/app/tds/pages/tds_payment.dart';
import 'package:moneycart/config/constants/app_constants.dart';

class TdsDetails extends StatefulWidget {
  const TdsDetails({super.key});

  @override
  State<TdsDetails> createState() => _TdsDetailsState();
}

class _TdsDetailsState extends State<TdsDetails> {
  final controller = Get.put(TdsController());
  List<dynamic>? _currentYearDetails;
  List<dynamic>? _previousYearDetails;

  late String _currentYear;
  late String _previousYear;

  bool _previousYearSelected = true;

  int get totalTds {
    int totalTds = 0;

    if (_currentYearDetails != null) {
      totalTds += _currentYearDetails!
          .fold(0, (sum, item) => sum + parseValue(item['tds']));
    }
    if (_previousYearSelected && _previousYearDetails != null) {
      totalTds += _previousYearDetails!
          .fold(0, (sum, item) => sum + parseValue(item['tds']));
    }

    return totalTds;
  }

  String get payment {
    int tdsCharge = totalTds;
    if (tdsCharge >= 0 && tdsCharge <= 2000) {
      return '249';
    } else if (tdsCharge > 2000 && tdsCharge <= 5000) {
      return '499';
    } else if (tdsCharge > 5000) {
      return '999';
    } else {
      return '0';
    }
  }

  @override
  void initState() {
    super.initState();
    final currentDateTime = DateTime.now();
    _currentYear = DateFormat('yyyy').format(currentDateTime);
    _previousYear =
        DateFormat('yyyy').format(DateTime(currentDateTime.year - 1));
    fetchAndSetDetails();
  }

  Future<void> fetchAndSetDetails() async {
    final snapshot = await controller.fetchTdsDetails();
    final data = snapshot.data();
    if (data != null) {
      setState(() {
        _currentYearDetails = data['tdsData$_currentYear'] as List<dynamic>?;
        _previousYearDetails = data['tdsData$_previousYear'] as List<dynamic>?;
      });
    }
  }

  Widget buildMessage() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            'Congratulations, You are eligible for refund of the below TDS amount.'),
        Text(
            'Please pay the fees to help us file the Income Tax return and claim the refund.'),
      ],
    );
  }

  int parseValue(dynamic value) {
    if (value is String) {
      return int.tryParse(value) ?? 0;
    } else if (value is int) {
      return value;
    }
    return 0;
  }

  Widget buildTdsAmountList(String year, List<dynamic>? details) {
    if (details == null || details.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('No TDS details available for this year.'),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: details.length,
      itemBuilder: (context, index) {
        final detail = details[index];
        return ListTile(
          title: Text('TDS Amount for $year: ${detail['tds']}'),
          subtitle: Text('Date: ${detail['date']}'),
        );
      },
    );
  }

  Widget buildTdsDetailsCard() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildMessage(),
            const SizedBox(height: 10),
            buildTdsAmountList(_currentYear, _currentYearDetails),
            const SizedBox(height: 10),
            if (_previousYearSelected)
              buildTdsAmountList(_previousYear, _previousYearDetails),
            const SizedBox(height: 10),
            const Text(
              'Refund: ₹0',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Payable Amount: ₹$payment',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TDS Details',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: Navigator.of(context).canPop(),
        backgroundColor: const Color(0xFF56c596),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: RefreshIndicator(
          onRefresh: fetchAndSetDetails,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  AppConstants.taxImg,
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width * 0.9,
                ),
                const SizedBox(height: 10),
                buildTdsDetailsCard(),
                const SizedBox(height: 50),
                PrimaryButton(
                  text: 'Pay Now',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TdsPayment(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
