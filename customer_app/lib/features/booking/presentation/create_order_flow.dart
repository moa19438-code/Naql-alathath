import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import 'create_order_model.dart';
import 'step_items_page.dart';
import 'step_locations_page.dart';
import 'step_schedule_page.dart';
import 'step_service_page.dart';

class CreateOrderFlow extends StatefulWidget {
  final String? from;
  final String? to;

  const CreateOrderFlow({super.key, this.from, this.to});

  @override
  State<CreateOrderFlow> createState() => _CreateOrderFlowState();
}

class _CreateOrderFlowState extends State<CreateOrderFlow> {
  int step = 0;
  CreateOrderModel model = const CreateOrderModel();

  @override
  void initState() {
    super.initState();

    final from = widget.from?.trim();
    final to = widget.to?.trim();

    if ((from != null && from.isNotEmpty) || (to != null && to.isNotEmpty)) {
      model = model.copyWith(
        fromAddress: (from != null && from.isNotEmpty) ? from : null,
        toAddress: (to != null && to.isNotEmpty) ? to : null,
      );
    }
  }

  void _next() => setState(() => step++);
  void _back() => setState(() => step--);

  void _close() {
    // ✅ إذا ما فيه صفحة قبلها (دخلت بـ go) ما راح يشتغل pop
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(CustomerRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return switch (step) {
      0 => StepServicePage(
          selected: model.serviceType,
          onSelect: (v) =>
              setState(() => model = model.copyWith(serviceType: v)),
          onClose: _close,
          onNext: model.isStep1Valid ? _next : null,
        ),
      1 => StepLocationsPage(
          initialFrom: model.fromAddress ?? '',
          initialTo: model.toAddress ?? '',
          onClose: _close,
          onBack: _back,
          onNext: (from, to) {
            final tmp = model.copyWith(fromAddress: from, toAddress: to);
            setState(() => model = tmp);
            if (tmp.isStep2Valid) _next();
          },
        ),
      2 => StepItemsPage(
          initialNotes: model.itemsNotes ?? '',
          onClose: _close,
          onBack: _back,
          onNext: (notes) {
            setState(() => model = model.copyWith(itemsNotes: notes));
            _next();
          },
        ),
      _ => StepSchedulePage(
          model: model,
          onClose: _close,
          onBack: _back,
          onConfirm: (dt) {
            setState(() => model = model.copyWith(scheduledAt: dt));

            // ✅ مؤقتًا نرجع للهوم بدل pop (لأنه ممكن ما يشتغل مع go)
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(CustomerRoutes.home);
            }
          },
        ),
    };
  }
}
