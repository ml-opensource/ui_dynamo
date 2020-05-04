import 'package:flutter/material.dart';
import 'package:flutter_storybook/actions/actions_extensions.dart';
import 'package:flutter_storybook/props/props_extensions.dart';
import 'package:provider/provider.dart';

class DrawerProvider extends ChangeNotifier {
  Key _selectedFolderKey;
  Key _selectedPageKey;

  void select(BuildContext context, Key folderKey, Key pageKey) {
    _selectedFolderKey = folderKey;
    _selectedPageKey = pageKey;
    props(context).reset();
    actions(context).reset();
    notifyListeners();
  }

  Key get folderKey => _selectedFolderKey;

  Key get pageKey => _selectedPageKey;
}

DrawerProvider drawer(BuildContext context) =>
    Provider.of<DrawerProvider>(context);
