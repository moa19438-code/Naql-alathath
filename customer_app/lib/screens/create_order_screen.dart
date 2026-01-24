import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _pickup = TextEditingController();
  final _dropoff = TextEditingController();
  final _workers = TextEditingController();

  String vehicle = 'truck';

  void _submitOrder() async {
    final response = await ApiService.createOrder(
      pickup: _pickup.text,
      dropoff: _dropoff.text,
      workers: int.tryParse(_workers.text) ?? 1,
      vehicle: vehicle,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order Created: ID ${response['id']}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء طلب')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _pickup, decoration: const InputDecoration(labelText: 'موقع الاستلام')),
            TextField(controller: _dropoff, decoration: const InputDecoration(labelText: 'موقع التسليم')),
            TextField(controller: _workers, decoration: const InputDecoration(labelText: 'عدد العمال'), keyboardType: TextInputType.number),
            DropdownButton<String>(
              value: vehicle,
              items: const [
                DropdownMenuItem(value: 'truck', child: Text('شاحنة')),
                DropdownMenuItem(value: 'small', child: Text('صغيرة')),
              ],
              onChanged: (v) => setState(() => vehicle = v!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('إرسال الطلب'),
              onPressed: _submitOrder,
            )
          ],
        ),
      ),
    );
  }
}
