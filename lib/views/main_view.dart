import 'package:flutter/material.dart';

// Placeholder view.
class MainView extends StatelessWidget {
  static const viewId = 'MainView';

  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Text(
            'Placeholder MainView',
          ),
        ),
      );
}
