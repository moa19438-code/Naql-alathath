class PaymentService {
  static Future<bool> pay(double amount) async {
    await Future.delayed(const Duration(seconds: 2));
    return true; // دائمًا نجاح
  }
}
