import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:moneycart/app/pf/pages/pf_form.dart';
import 'package:moneycart/config/constants/app_constants.dart';
import 'package:moneycart/config/theme/app_pallete.dart';

class PfServicesPage extends StatefulWidget {
  const PfServicesPage({super.key});

  @override
  State<PfServicesPage> createState() => _PfServicesPageState();
}

class _PfServicesPageState extends State<PfServicesPage> {
  bool? isEmployed;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showEmploymentDialog();
    });
  }

  void _showEmploymentDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Are you currently employed?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  isEmployed = true;
                });
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  isEmployed = false;
                });
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isEmployed == null) {
      return const Scaffold(
        body: SizedBox.shrink(),
      );
    }

    /// Define the list of services dynamically using `AppConstants`
    List<Map<String, dynamic>> services = [
      {
        "title": AppConstants.pfWithdrawal,
        "icon": AppConstants.pfWithdrawalImg,
        "screen": PfForm(
          header: "PF Withdrawal",
          option: "bank",
        ),
      },
      {
        "title": AppConstants.pfTransfer,
        "icon": AppConstants.pfTransferImg,
        "screen": PfForm(
          header: "PF Transfer",
          option: "bank",
        ),
      },
      if (isEmployed == false)
        {
          "title": AppConstants.pfAdvance,
          "icon": AppConstants.pfAdvanceImg,
          "screen": PfForm(
            header: "PF Advance",
            option: "bank",
          ),
        },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PF Services',
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
      ),
      backgroundColor: Colors.white10,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: services.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final service = services[index];
            return ListTile(
              leading: SvgPicture.asset(
                service["icon"], // SVG icon from `AppConstants`
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppPallete.secondary,
                  BlendMode.srcIn,
                ),
              ),
              title: Text(
                service["title"], // Title from `AppConstants`
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                Get.to(service["screen"]);
              },
            );
          },
        ),
      ),
    );
  }
}
