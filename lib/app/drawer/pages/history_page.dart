import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneycart/config/theme/app_pallete.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample ride history data
    final List<Ride> rideHistory = [
      Ride(
        type: 'Car',
        date: '2024-07-20',
        locationFrom: 'Location A',
        locationTo: 'Location B',
        time: '10:00 AM',
        payment: '\$20.00',
      ),
      Ride(
        type: 'Bike',
        date: '2024-07-19',
        locationFrom: 'Location C',
        locationTo: 'Location D',
        time: '3:00 PM',
        payment: '\$15.00',
      ),
      // Add more ride history here
    ];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Ride History',
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: rideHistory.length,
            itemBuilder: (context, index) {
              final ride = rideHistory[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 4,
                child: ListTile(
                  leading: Icon(
                    _getRideIcon(ride.type),
                    color: AppPallete.primary,
                    size: 40,
                  ),
                  title: Text(
                    '${ride.locationFrom} to ${ride.locationTo}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  subtitle: Text(
                    'Date: ${ride.date}\nTime: ${ride.time}\nPayment: ${ride.payment}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  IconData _getRideIcon(String type) {
    switch (type) {
      case 'Car':
        return Icons.directions_car;
      case 'Bike':
        return Icons.directions_bike;
      case 'Bus':
        return Icons.directions_bus;
      default:
        return Icons.help;
    }
  }
}

class Ride {
  final String type;
  final String date;
  final String locationFrom;
  final String locationTo;
  final String time;
  final String payment;

  Ride({
    required this.type,
    required this.date,
    required this.locationFrom,
    required this.locationTo,
    required this.time,
    required this.payment,
  });
}
