import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:moneycart/app/referral/controllers/referral_controller.dart';
import 'package:moneycart/config/theme/app_pallete.dart';
import 'package:moneycart/core/utils/format_date.dart';

class ReferralList extends StatelessWidget {
  ReferralList({super.key});
  final ReferralController _referralController = Get.put(ReferralController());
  Color getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Processing':
        return Colors.yellow;
      case 'Complete':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppPallete.secondary,
            size: 19,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          'Referrals',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppPallete.secondary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
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
            onPressed: () {
              _referralController.fetchDocuments();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppPallete.boldprimary,
        onRefresh: _referralController.fetchDocuments,
        child: Obx(() {
          if (_referralController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppPallete.primary,
                ),
              ),
            );
          }

          if (_referralController.documents.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svgs/no_lists.svg',
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No referral found',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins'),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Check back later or upload a new document.',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontFamily: 'Poppins'),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      _referralController.fetchDocuments();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPallete.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: _referralController.documents.length,
            itemBuilder: (context, index) {
              final doc = _referralController.documents[index];
              final DateTime date = (doc['date'] as Timestamp).toDate();

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: SvgPicture.asset(
                    'assets/icons/link.svg',
                    colorFilter: const ColorFilter.mode(
                      AppPallete.primary,
                      BlendMode.srcIn,
                    ),
                    width: 30,
                    height: 30,
                  ),
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        doc['name'] ?? 'N/A',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          color: AppPallete.blackSecondary,
                        ),
                      ),
                      Text(
                        formatDateByddMMYYYY(date),
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          doc['status'] ?? 'Pending',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            color: getStatusColor(doc['status']),
                          ),
                        ),
                        Text(
                          formatTime(date),
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
