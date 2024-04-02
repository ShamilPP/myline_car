class OrderItem {
  final String? id;
  final String carId;
  final String userId;
  final String token;
  late int status;
  final int type;
  final DateTime orderTime;

  OrderItem({
    this.id,
    required this.carId,
    required this.userId,
    required this.token,
    required this.status,
    required this.type,
    required this.orderTime,
  });
}
