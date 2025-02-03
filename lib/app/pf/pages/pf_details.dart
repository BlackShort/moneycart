import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneycart/app/common/widgets/loading_button.dart';
import 'package:moneycart/app/pf/controllers/pf_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moneycart/app/pf/pages/pf_final_otp.dart';
import 'package:moneycart/config/theme/app_pallete.dart';

class PfDetails extends StatefulWidget {
  const PfDetails({super.key});

  @override
  State<PfDetails> createState() => _PfDetailsState();
}

class _PfDetailsState extends State<PfDetails> {
  final controller = Get.put(PfController());
  List<dynamic>? _currentYearDetails;
  List<dynamic>? _previousYearDetails;

  late String _currentYear;
  late String _previousYear;

  final bool _previousYearSelected = true;

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
    if (tdsCharge >= 1 && tdsCharge <= 1000) {
      return '149';
    } else if (tdsCharge >= 1001 && tdsCharge <= 2500) {
      return '249';
    } else if (tdsCharge >= 2501 && tdsCharge <= 5000) {
      return '499';
    } else if (tdsCharge > 5000 && tdsCharge <= 15000) {
      return '999';
    } else if (tdsCharge > 15000 && tdsCharge <= 18000) {
      return '1499';
    } else if (tdsCharge > 18000) {
      return '1999';
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
          'Congratulations!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: AppPallete.blackSecondary,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'Your EPF details have been successfully fetched. Please pay the platform fees to help us file your claim and process the EPF refund.',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            color: AppPallete.secondary,
          ),
        ),
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
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'No TDS details available for the year: $year.',
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: AppPallete.secondary,
          ),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: details.length,
      itemBuilder: (context, index) {
        final detail = details[index];
        return ListTile(
          title: Text(
            'TDS Amount for $year: ${detail['tds']}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          subtitle: Text('Date: ${detail['date']}'),
        );
      },
    );
  }

  Widget buildPfDetailsCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 20.0),
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
            const Divider(height: 30, thickness: 1, color: Colors.grey),
            buildTdsAmountList(_currentYear, _currentYearDetails),
            const Divider(height: 30, thickness: 1, color: Colors.grey),
            Text(
              'Total EPF: ₹$totalTds',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: AppPallete.blackSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Total EPS: ₹$totalTds',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: AppPallete.blackSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Payable Amount: ₹$payment',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: AppPallete.blackSecondary,
              ),
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
          'PF Details',
          style: TextStyle(
            color: AppPallete.secondary,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppPallete.secondary,
            size: 19,
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/refresh.svg',
              width: 22,
              height: 22,
              colorFilter: const ColorFilter.mode(
                AppPallete.secondary,
                BlendMode.srcIn,
              ),
            ),
            onPressed: fetchAndSetDetails,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: RefreshIndicator(
          color: AppPallete.boldprimary,
          onRefresh: fetchAndSetDetails,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildPfDetailsCard(),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => LoadingButton(
                      isLoading: controller.isLoading.value,
                      text: 'Pay Now',
                      onPressed: () {
                        Get.off(() => const PfFinalOtp(
                              enableOtp: true,
                            ));
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const TdsPayment(),
                        //   ),
                        // );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
