import 'package:catalyst/core/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  const BaseScaffold({
    super.key,
    required this.child,
    this.drawer,
    this.appBar,
    this.title,
    this.showAppBar = true,
  });

  final Widget child;
  final Widget? drawer;
  final PreferredSizeWidget? appBar;
  final String? title;
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEEEEEE),
      drawer: drawer,
      appBar:
          appBar ??
          (showAppBar && title != null ? CustomAppBar(title: title) : null),
      body: child,
    );
  }
}
