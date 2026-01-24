class ApiService {
  static final List<Map<String, dynamic>> _orders =
      ApiServiceShared.orders; // مشاركة وهمية

  static Future<List> getOrders() async {
    await Future.delayed(const Duration(seconds: 1));
    return _orders;
  }

  static Future acceptOrder(int id) async {
    final order = _orders.firstWhere((o) => o['id'] == id);
    order['status'] = 'accepted';
  }
}

/// ملف مشترك (أنشئه مرة واحدة)
class ApiServiceShared {
  static final List<Map<String, dynamic>> orders = [];
}
