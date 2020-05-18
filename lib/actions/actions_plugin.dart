import 'package:flutter_storybook/actions/actions_extensions.dart';
import 'package:flutter_storybook/actions/actions_ui.dart';
import 'package:flutter_storybook/plugins/plugin.dart';

StoryBookPlugin actionsPlugin() => StoryBookPlugin(
      provider: (context) => ActionsProvider(),
      bottomTabText: 'Actions',
      bottomTabPane: (context) => ActionsDisplay(),
    );
