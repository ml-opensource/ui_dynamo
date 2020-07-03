import 'package:example/main.dart';
import 'package:example/pages/person_detail.dart';
import 'package:example/dynamo/alerts_page.dart';
import 'package:example/dynamo/buttons_page.dart';
import 'package:example/dynamo/cells_page.dart';
import 'package:example/dynamo/inputs_page.dart';
import 'package:example/dynamo/main_cell_list_page.dart';
import 'package:example/dynamo/radios_page.dart';
import 'package:example/dynamo/text_style_page.dart';
import 'package:example/dynamo/toasts_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ui_dynamo/ui_dynamo.dart';
import 'package:ui_dynamo/mediaquery/device_sizes.dart';

import '../widgets/cells.dart';

void main() => runApp(AppDynamo());

class AppDynamo extends StatelessWidget {
  const AppDynamo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dynamo.withApp(
      buildApp(),
      previewRoutes: {
        '/details/:item': (context) => PersonDetail(
              item: MainCellItem(
                  'P', 'Preview Item', 'This is a preview Route', 0),
            )
      },
      data: DynamoData(
        defaultDevice: DeviceSizes.iphoneX,
        items: [
          DynamoPage.storyboard(title: 'Home Flow', flowMapping: {
            'home': [
              '/home',
              '/company',
            ],
          }),
          DynamoPage.storyboard(title: 'Company Details', flowMapping: {
            'home': [
              '/company',
              '/details/:item',
            ],
          }),
          DynamoFolder.of(title: 'Widgets', pages: [
            buildTextStylePage(),
            buildButtonsPage(),
            buildToastPage(),
            buildRadiosPage(),
            buildInputsPage(),
          ]),
          DynamoFolder.of(title: 'Composite', pages: [
            buildAlertsPage(),
            buildCellsPage(),
            buildMainCellListPage(),
          ]),
        ],
      ),
    );
  }
}
