import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/media_utils.dart';
import 'package:flutter_storybook/mediaquery/device_sizes.dart';
import 'package:flutter_storybook/mediaquery/screen_size_chooser.dart';
import 'package:flutter_storybook/mediaquery/text_scale.dart';
import 'package:flutter_storybook/mediaquery/zoom_controls.dart';
import 'package:flutter_storybook/ui/utils/size+extensions.dart';

class MediaQueryToolbar extends StatefulWidget {
  final MediaQueryData currentMediaQuery;
  final DeviceInfo currentDeviceSelected;
  final Function(MediaQueryData) onMediaQueryChange;
  final Function(DeviceInfo) onDeviceInfoChanged;
  final Function(double) updateScale;
  final double scale;

  const MediaQueryToolbar({
    Key key,
    @required this.currentMediaQuery,
    @required this.onMediaQueryChange,
    @required this.onDeviceInfoChanged,
    @required this.currentDeviceSelected,
    @required this.updateScale,
    @required this.scale,
  }) : super(key: key);

  @override
  _MediaQueryToolbarState createState() => _MediaQueryToolbarState();
}

class _MediaQueryToolbarState extends State<MediaQueryToolbar> {
  bool isExpanded = false;

  void _deviceSelected(BuildContext context, DeviceInfo device) {
    widget.onDeviceInfoChanged(device);
    widget.onMediaQueryChange(widget.currentMediaQuery.copyWith(
      size: device.logicalSize.boundedSize(context),
    ));
  }

  void _toggleBrightness() {
    widget.onMediaQueryChange(widget.currentMediaQuery.copyWith(
      platformBrightness:
          widget.currentMediaQuery.platformBrightness == Brightness.light
              ? Brightness.dark
              : Brightness.light,
    ));
  }

  void _toggleHighContrast() {
    widget.onMediaQueryChange(widget.currentMediaQuery.copyWith(
      highContrast: !widget.currentMediaQuery.highContrast,
    ));
  }

  void _toggleInvertColors() {
    widget.onMediaQueryChange(widget.currentMediaQuery.copyWith(
      invertColors: !widget.currentMediaQuery.invertColors,
    ));
  }

  void _textScaleFactorChanged(double value) {
    widget.onMediaQueryChange(widget.currentMediaQuery.copyWith(
      textScaleFactor: value,
    ));
  }

  void _toggleAnimations() {
    widget.onMediaQueryChange(widget.currentMediaQuery.copyWith(
      disableAnimations: !widget.currentMediaQuery.disableAnimations,
    ));
  }

  Widget buildDivider() => Container(
        height: 15,
        child: VerticalDivider(),
      );

  List<Widget> topBarList() {
    return [
      IconButton(
        icon: Icon(widget.currentMediaQuery.disableAnimations
            ? Icons.directions_walk
            : Icons.directions_run),
        tooltip: 'Toggle Animations ' +
            (widget.currentMediaQuery.disableAnimations ? 'On' : 'Off'),
        onPressed: _toggleAnimations,
      ),
      buildDivider(),
      IconButton(
        icon: Icon(
          widget.currentMediaQuery.invertColors
              ? Icons.invert_colors
              : Icons.invert_colors_off,
        ),
        tooltip: 'Invert Colors ' +
            (widget.currentMediaQuery.invertColors ? 'Off' : 'On'),
        onPressed: _toggleInvertColors,
      ),
      buildDivider(),
      IconButton(
        icon: Icon(
          widget.currentMediaQuery.highContrast
              ? Icons.tonality
              : Icons.panorama_fish_eye,
        ),
        tooltip: 'High Contrast ' +
            (widget.currentMediaQuery.highContrast ? 'Off' : 'On'),
        onPressed: _toggleHighContrast,
      ),
      buildDivider(),
      IconButton(
        icon: Icon(
            widget.currentMediaQuery.platformBrightness == Brightness.light
                ? Icons.brightness_7
                : Icons.brightness_3),
        tooltip: 'Make Brightness ' +
            (widget.currentMediaQuery.platformBrightness == Brightness.light
                ? 'Dark'
                : 'Light'),
        onPressed: () {
          _toggleBrightness();
        },
      ),
    ];
  }

  buildIcons(BuildContext context) {
    final expandable = isMobile(context);
    if (expandable && !isExpanded) {
      return Row(
        children: [...topBarList()],
      );
    }
    return Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        ...topBarList(),
        buildDivider(),
        AdjustableNumberScaleWidget(
          scaleFactor: widget.currentMediaQuery.textScaleFactor,
          scaleFactorChanged: _textScaleFactorChanged,
          displayIcon: Icons.text_fields,
          tooltip: 'Select a Text Scale',
        ),
        buildDivider(),
        MediaChooserButton(
          deviceSelected: (value) => _deviceSelected(context, value),
          selectedDevice: widget.currentDeviceSelected,
        ),
        ZoomControls(
          scale: widget.scale,
          updateScale: widget.updateScale,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardmargin = isTablet(context)
        ? EdgeInsets.only(left: 4.0, right: 4.0)
        : EdgeInsets.all(0);
    return Card(
      margin: cardmargin,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(8.0),
          bottomLeft: Radius.circular(8.0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: buildIcons(context),
          ),
          if (isMobile(context))
            SizedBox(
              width: 48,
              height: 48,
              child: InkWell(
                borderRadius: BorderRadius.circular(96.0),
                child: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),
            )
        ],
      ),
    );
  }
}
