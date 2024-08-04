import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String name;
  String email;
  String? gender;
  String phone;
  String address;
  String profile;
  String? fcmToken;
  String? referral;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.gender,
    required this.phone,
    required this.address,
    required this.profile,
    this.fcmToken,
    this.referral,
  });

  // Create UserModel from Firestore snapshot
  factory UserModel.fromSnapshot(DocumentSnapshot<Object?> document) {
    final data = document.data() as Map<String, dynamic>;
    return UserModel(
      id: document.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      gender: data['gender'],
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      profile: data['profile'] ?? '',
      fcmToken: data['fcmToken'],
      referral: data['referral'],
    );
  }

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'gender': gender,
      'phone': phone,
      'address': address,
      'profile': profile,
      'fcmToken': fcmToken,
      'referral': referral,
    };
  }
}
