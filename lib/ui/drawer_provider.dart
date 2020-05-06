import 'package:flutter/material.dart';
import 'package:flutter_storybook/actions/actions_extensions.dart';
import 'package:flutter_storybook/models.dart';
import 'package:flutter_storybook/props/props_extensions.dart';
import 'package:flutter_storybook/ui/widgets/page.dart';
import 'package:provider/provider.dart';

class DrawerProvider extends ChangeNotifier {
  Key _selectedFolderKey = ValueKey('Home');
  Key _selectedPageKey = ValueKey('Home');

  void select(BuildContext context, Key folderKey, Key pageKey,
      {bool popDrawer = false}) {
    _selectedFolderKey = folderKey;
    _selectedPageKey = pageKey;
    props(context).reset();
    actions(context).reset();
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

StoryBookPage selectedPageFromWidget(StoryBookData data, BuildContext context) {
  final selectedFolderKey = drawer(context).folderKey;
  final selectedPageKey = drawer(context).pageKey;
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
