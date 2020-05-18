import 'package:flutter_storybook/actions/actions_extensions.dart';
import 'package:flutter_storybook/actions/actions_ui.dart';
import 'package:flutter_storybook/plugins/plugin.dart';
import 'package:provider/provider.dart';

StoryBookPlugin actionsPlugin() => StoryBookPlugin<ActionsProvider>(
      provider: ChangeNotifierProvider(create: (context) => ActionsProvider()),
      bottomTabText: 'Actions',
      bottomTabPane: (context) => ActionsDisplay(),
    );
