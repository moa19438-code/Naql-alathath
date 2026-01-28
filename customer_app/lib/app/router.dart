import 'package:go_router/go_router.dart';
import '../features/home/presentation/customer_home_page.dart';
import '../features/booking/presentation/create_order_page.dart';

class AppRoutes {
  static const home = '/';
  static const createOrder = '/create-order';
}

GoRouter buildCustomerRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const CustomerHomePage(),
      ),
      GoRoute(
        path: AppRoutes.createOrder,
        builder: (context, state) => const CreateOrderPage(),
      ),
    ],
  );
}
