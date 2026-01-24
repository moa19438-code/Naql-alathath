import 'package:flutter/material.dart';
import '../services/api_service.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List orders = [];

  void _loadOrders() async {
    final response = await ApiService.getOrders();
    setState(() => orders = response);
  }

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طلبات النقل')),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (_, index) {
          final o = orders[index];
          return ListTile(
            title: Text('من: ${o['pickup']} → إلى: ${o['dropoff']}'),
            subtitle: Text('حالة: ${o['status']}'),
            trailing: ElevatedButton(
              child: const Text('قبول'),
              onPressed: () async {
                await ApiService.acceptOrder(o['id']);
                _loadOrders();
              },
            ),
          );
        },
      ),
    );
  }
}
