import 'package:flutter/material.dart';
import 'package:social_app/Views/Main/responsive_builder.dart';
import 'package:social_app/Views/View/Chat/MainRequests/mobile_requests_page.dart';

class MainRequestsScreen extends StatelessWidget {
  static const String requests = '/MainRequestsScreen';
  const MainRequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ResponsiveBuilderScreen(
        mobile: MobileRequestsPage()
    );
  }
}
