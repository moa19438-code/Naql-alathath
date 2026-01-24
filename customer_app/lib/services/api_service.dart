class ApiService {
  static final List<Map<String, dynamic>> _orders = [];

  static Future<Map<String, dynamic>> createOrder({
    required String pickup,
    required String dropoff,
    required int workers,
    required String vehicle,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final order = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'pickup': pickup,
      'dropoff': dropoff,
      'workers': workers,
      'vehicle': vehicle,
      'status': 'pending',
    };

    _orders.add(order);
    return order;
  }

  static List<Map<String, dynamic>> get orders => _orders;
}
