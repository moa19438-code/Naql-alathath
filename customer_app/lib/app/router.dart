import 'package:go_router/go_router.dart';
import '../features/home/presentation/customer_map_home_page.dart';
import '../features/booking/presentation/create_order_flow.dart';

class CustomerRoutes {
  static const home = '/';
  static const createOrder = '/create-order';
}

GoRouter buildCustomerRouter() {
  return GoRouter(
    initialLocation: CustomerRoutes.home,
    routes: [
      GoRoute(
        path: CustomerRoutes.home,
        builder: (context, state) => const CustomerMapHomePage(),
      ),
      GoRoute(
  path: CustomerRoutes.createOrder,
  builder: (context, state) {
    final from = state.uri.queryParameters['from'];
    final to = state.uri.queryParameters['to'];
    return CreateOrderFlow(from: from, to: to);
  },
),
