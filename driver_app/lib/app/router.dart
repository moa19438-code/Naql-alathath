import 'package:go_router/go_router.dart';
import '../features/home/presentation/driver_home_page.dart';

class DriverRoutes {
  static const home = '/';
}

GoRouter buildDriverRouter() {
  return GoRouter(
    initialLocation: DriverRoutes.home,
    routes: [
      GoRoute(
        path: DriverRoutes.home,
        builder: (context, state) => const DriverHomePage(),
      ),
    ],
  );
}
