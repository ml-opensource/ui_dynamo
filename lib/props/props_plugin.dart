import 'package:flutter_storybook/plugins/plugin.dart';
import 'package:flutter_storybook/props/props_extensions.dart';
import 'package:flutter_storybook/props/props_ui.dart';
import 'package:provider/provider.dart';

StoryBookPlugin propsPlugin() => StoryBookPlugin<PropsProvider>(
      provider: ChangeNotifierProvider(
          create: (context) => PropsProvider()),
      bottomTabText: 'Props',
      bottomTabPane: (context) => PropsDisplay(),
    );
