import 'package:example/main.dart';
import 'package:example/pages/person_detail.dart';
import 'package:example/storybook/alerts_page.dart';
import 'package:example/storybook/buttons_page.dart';
import 'package:example/storybook/cells_page.dart';
import 'package:example/storybook/main_cell_list_page.dart';
import 'package:example/storybook/radios_page.dart';
import 'package:example/storybook/text_style_page.dart';
import 'package:example/storybook/toasts_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/flutter_storybook.dart';
import 'package:flutter_storybook/mediaquery/device_sizes.dart';

import '../widgets/cells.dart';

void main() => runApp(AppStoryBook());

class AppStoryBook extends StatelessWidget {
  const AppStoryBook({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoryBook.withApp(
      buildApp(),
      previewRoutes: {
        '/details/:item': (context) => PersonDetail(
              item: MainCellItem(
                  'P', 'Preview Item', 'This is a preview Route', 0),
            )
      },
      data: StoryBookData(
        title: Text('Example Storybook'),
        defaultDevice: DeviceSizes.iphoneX,
        items: [
          StoryBookPage.storyboard(title: 'Home Flow', routesMapping: {
            'home': [
              '/home',
              '/company',
            ],
          }),
          StoryBookPage.storyboard(title: 'Company Details', routesMapping: {
            'home': [
              '/company',
              '/details/:item',
            ],
          }),
          StoryBookFolder.of(title: 'Widgets', pages: [
            buildTextStylePage(),
            buildButtonsPage(),
            buildToastPage(),
            buildRadiosPage(),
          ]),
          StoryBookFolder.of(title: 'Composite', pages: [
            buildAlertsPage(),
            buildCellsPage(),
            buildMainCellListPage(),
          ]),
        ],
      ),
    );
  }
}
