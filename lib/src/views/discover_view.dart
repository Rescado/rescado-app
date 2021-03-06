import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/utils/extensions.dart';
import 'package:rescado/src/views/buttons/appbar_button.dart';
import 'package:rescado/src/views/buttons/rounded_button.dart';
import 'package:rescado/src/views/labels/page_title.dart';

// Placeholder view.
class DiscoverView extends StatelessWidget {
  static const viewId = 'DiscoverView';
  static const tabIndex = 0;

  const DiscoverView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Scrollbar(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                floating: true,
                actions: <Widget>[
                  AppBarButton(
                    semanticsLabel: 'hello',
                    svgAsset: RescadoConstants.iconSettings,
                    onPressed: () => {print('settings')}, // ignore: avoid_print
                  ),
                ],
                flexibleSpace: PageTitle(
                  label: context.i10n.labelDiscover,
                ),
              ),
              SliverToBoxAdapter(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'Placeholder DiscoverView',
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      // For demo purposes
                      RoundedButton(
                        semanticsLabel: 'Do not press',
                        svgAsset: RescadoConstants.iconHeartBroken,
                        onPressed: () {
                          // 💣
                          FirebaseCrashlytics.instance.crash();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
