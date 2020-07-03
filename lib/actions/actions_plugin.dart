import 'package:ui_dynamo/actions/actions_extensions.dart';
import 'package:ui_dynamo/actions/actions_ui.dart';
import 'package:ui_dynamo/plugins/plugin.dart';
import 'package:provider/provider.dart';

/// Returns a plugin instance for [ActionsProvider] with a bottom tab text display.
DynamoPlugin actionsPlugin() => DynamoPlugin<ActionsProvider>(
      provider: ChangeNotifierProvider(create: (context) => ActionsProvider()),
      tabText: 'Actions',
      tabPane: (context) => ActionsDisplay(),
    );
