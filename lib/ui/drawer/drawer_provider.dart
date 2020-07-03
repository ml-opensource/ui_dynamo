import 'package:flutter/material.dart';
import 'package:ui_dynamo/actions/actions_extensions.dart';
import 'package:ui_dynamo/mediaquery/offset_plugin.dart';
import 'package:ui_dynamo/mediaquery/override_media_query_plugin.dart';
import 'package:ui_dynamo/models.dart';
import 'package:ui_dynamo/props/props_plugin.dart';
import 'package:ui_dynamo/ui/model/page.dart';
import 'package:provider/provider.dart';

class DrawerProvider extends ChangeNotifier {
  Key _selectedFolderKey = ValueKey('Home');
  Key _selectedPageKey = ValueKey('Home');

  void select(BuildContext context, Key folderKey, Key pageKey,
      {bool popDrawer = false}) {
    _selectedFolderKey = folderKey;
    _selectedPageKey = pageKey;
    context.safeProps?.reset();
    context.safeActions?.reset();
    context.mediaQueryProvider.resetScreenAdjustments(context.offsetProvider,
        realQuery: MediaQuery.of(context));
    if (popDrawer) {
      Navigator.of(context).pop();
    }
    notifyListeners();
  }

  Key get folderKey => _selectedFolderKey;

  Key get pageKey => _selectedPageKey;
}

DrawerProvider drawer(BuildContext context) =>
    Provider.of<DrawerProvider>(context);

DynamoPage selectedPageFromWidget(DynamoData data, BuildContext context) {
  final drawer = context.drawerProvider;
  final selectedFolderKey = drawer.folderKey;
  final selectedPageKey = drawer.pageKey;
  if (selectedFolderKey != null && selectedPageKey != null) {
    final folder = data.items.firstWhere(
        (element) => element.key == selectedFolderKey,
        orElse: () => null);
    if (folder != null) {
      return folder.pageFromKey(selectedPageKey);
    }
  }
  return null;
}

extension DrawerProviderExtension on BuildContext {
  DrawerProvider get drawerProvider => drawer(this);
}
