import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';

class AppScaffold extends StatelessWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget body;
  final Widget? bottomNavigationBar;

  const AppScaffold({
    super.key,
    this.title,
    this.actions,
    required this.body,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (title == null)
          ? null
          : AppBar(
              title: Text(title!),
              actions: actions,
            ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: body,
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
