import 'package:flutter_storybook/plugins/plugin.dart';
import 'package:flutter_storybook/props/props_extensions.dart';
import 'package:flutter_storybook/props/props_ui.dart';

StoryBookPlugin propsPlugin() => StoryBookPlugin(
      provider: (context) => PropsProvider(),
      bottomTabText: 'Props',
      bottomTabPane: (context) => PropsDisplay(),
    );
