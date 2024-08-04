class RideModel {
  final String id;
  final String destination;
  final double distance;
  final String status;
  final String userId;

  RideModel({
    required this.id,
    required this.destination,
    required this.distance,
    required this.status,
    required this.userId,
  });

  factory RideModel.fromMap(Map<String, dynamic> map) {
    return RideModel(
      id: map['id'] ?? '',
      destination: map['destination'] ?? '',
      distance: map['distance'] ?? 0.0,
      status: map['status'] ?? '',
      userId: map['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'destination': destination,
      'distance': distance,
      'status': status,
      'userId': userId,
    };
  }

  RideModel copyWith({
    String? id,
    String? destination,
    double? distance,
    String? status,
    String? userId,
  }) {
    return RideModel(
      id: id ?? this.id,
      destination: destination ?? this.destination,
      distance: distance ?? this.distance,
      status: status ?? this.status,
      userId: userId ?? this.userId,
    );
  }
}
