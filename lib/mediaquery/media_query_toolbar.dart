import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/mediaquery/device_sizes.dart';
import 'package:flutter_storybook/mediaquery/screen_size_chooser.dart';
import 'package:flutter_storybook/mediaquery/text_scale.dart';
import 'package:flutter_storybook/ui/widgets/size+extensions.dart';

class MediaQueryToolbar extends StatelessWidget {
  final MediaQueryData currentMediaQuery;
  final DeviceInfo currentDeviceSelected;
  final Function(MediaQueryData) onMediaQueryChange;
  final Function(DeviceInfo) onDeviceInfoChanged;

  const MediaQueryToolbar({
    Key key,
    @required this.currentMediaQuery,
    @required this.onMediaQueryChange,
    @required this.onDeviceInfoChanged,
    @required this.currentDeviceSelected,
  }) : super(key: key);

  void _deviceSelected(BuildContext context, DeviceInfo device) {
    onDeviceInfoChanged(device);
    onMediaQueryChange(currentMediaQuery.copyWith(
      size: device.size.boundedSize(context),
    ));
  }

  void _toggleBrightness() {
    onMediaQueryChange(currentMediaQuery.copyWith(
      platformBrightness:
          currentMediaQuery.platformBrightness == Brightness.light
              ? Brightness.dark
              : Brightness.light,
    ));
  }

  void _toggleHighContrast() {
    onMediaQueryChange(currentMediaQuery.copyWith(
      highContrast: !currentMediaQuery.highContrast,
    ));
  }

  void _toggleInvertColors() {
    onMediaQueryChange(currentMediaQuery.copyWith(
      invertColors: !currentMediaQuery.invertColors,
    ));
  }

  void _textScaleFactorChanged(double value) {
    onMediaQueryChange(currentMediaQuery.copyWith(
      textScaleFactor: value,
    ));
  }

  void _toggleAnimations() {
    onMediaQueryChange(currentMediaQuery.copyWith(
      disableAnimations: !currentMediaQuery.disableAnimations,
    ));
  }

  void _devicePixelRatioChanged(double value) {
    onMediaQueryChange(currentMediaQuery.copyWith(
      devicePixelRatio: value,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(8.0),
          bottomLeft: Radius.circular(8.0),
        ),
      ),
      child: Wrap(
        direction: Axis.horizontal,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          AdjustableNumberScaleWidget(
            scaleFactor: currentMediaQuery.devicePixelRatio,
            scaleFactorChanged: _devicePixelRatioChanged,
            displayIcon: Icons.aspect_ratio,
            tooltip: 'Select a device pixel ratio',
          ),
          IconButton(
            icon: Icon(currentMediaQuery.disableAnimations
                ? Icons.directions_walk
                : Icons.directions_run),
            tooltip: 'Toggle Animations ' +
                (currentMediaQuery.disableAnimations ? 'On' : 'Off'),
            onPressed: _toggleAnimations,
          ),
          Container(
            height: 15,
            child: VerticalDivider(),
          ),
          IconButton(
            icon: Icon(
              currentMediaQuery.invertColors
                  ? Icons.invert_colors
                  : Icons.invert_colors_off,
            ),
            tooltip: 'Invert Colors ' +
                (currentMediaQuery.invertColors ? 'Off' : 'On'),
            onPressed: _toggleInvertColors,
          ),
          Container(
            height: 15,
            child: VerticalDivider(),
          ),
          IconButton(
            icon: Icon(
              currentMediaQuery.highContrast
                  ? Icons.tonality
                  : Icons.panorama_fish_eye,
            ),
            tooltip: 'High Contrast ' +
                (currentMediaQuery.highContrast ? 'Off' : 'On'),
            onPressed: _toggleHighContrast,
          ),
          Container(
            height: 15,
            child: VerticalDivider(),
          ),
          AdjustableNumberScaleWidget(
            scaleFactor: currentMediaQuery.textScaleFactor,
            scaleFactorChanged: _textScaleFactorChanged,
            displayIcon: Icons.text_fields,
            tooltip: 'Select a Text Scale',
          ),
          Container(
            height: 15,
            child: VerticalDivider(),
          ),
          IconButton(
            icon: Icon(currentMediaQuery.platformBrightness == Brightness.light
                ? Icons.brightness_7
                : Icons.brightness_3),
            tooltip: 'Make Brightness ' +
                (currentMediaQuery.platformBrightness == Brightness.light
                    ? 'Dark'
                    : 'Light'),
            onPressed: () {
              _toggleBrightness();
            },
          ),
          Container(
            height: 15,
            child: VerticalDivider(),
          ),
          MediaChooserButton(
            deviceSelected: (value) => _deviceSelected(context, value),
            selectedDevice: currentDeviceSelected,
          ),
        ],
      ),
    );
  }
}
