import 'package:flutter_storybook/actions/actions_extensions.dart';
import 'package:flutter_storybook/actions/actions_ui.dart';
import 'package:flutter_storybook/plugins/plugin.dart';
import 'package:provider/provider.dart';

/// Returns a plugin instance for [ActionsProvider] with a bottom tab text display.
StoryBookPlugin actionsPlugin() => StoryBookPlugin<ActionsProvider>(
      provider: ChangeNotifierProvider(create: (context) => ActionsProvider()),
      bottomTabText: 'Actions',
      bottomTabPane: (context) => ActionsDisplay(),
    );
