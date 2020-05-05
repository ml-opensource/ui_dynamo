import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/mediaquery/device_sizes.dart';
import 'package:flutter_storybook/mediaquery/screen_size_chooser.dart';
import 'package:flutter_storybook/mediaquery/text_scale.dart';
import 'package:flutter_storybook/ui/materialapp+extensions.dart';
import 'package:flutter_storybook/ui/widgets/size+extensions.dart';

typedef MediaWidgetBuilder = Widget Function(BuildContext, MediaQueryData);

class MediaQueryChooser extends StatefulWidget {
  final MediaWidgetBuilder builder;
  final bool shouldScroll;
  final MaterialApp base;

  const MediaQueryChooser(
      {Key key,
      @required this.builder,
      this.shouldScroll = true,
      @required this.base})
      : super(key: key);

  factory MediaQueryChooser.mediaQuery(
          {WidgetBuilder builder, MaterialApp base}) =>
      MediaQueryChooser(
        builder: (context, data) =>
            MediaQuery(data: data, child: builder(context)),
        base: base,
      );

  @override
  _MediaQueryChooserState createState() => _MediaQueryChooserState();
}

String deviceDisplay(BuildContext context, DeviceInfo deviceInfo) {
  final boundedSize = deviceInfo.size.boundedSize(context);
  return "${deviceInfo.name} (${boundedSize.width.truncate()}x${boundedSize.height.truncate()})";
}

class _MediaQueryChooserState extends State<MediaQueryChooser> {
  MediaQueryData currentMediaQuery;
  DeviceInfo currentDeviceSelected = deviceSizes[0];

  void _deviceSelected(BuildContext context, DeviceInfo device) {
    setState(() {
      currentDeviceSelected = device; // reset if blank
      currentMediaQuery = currentMediaQuery.copyWith(
        size: device.size.boundedSize(context),
      );
    });
  }

  void _toggleBrightness() {
    setState(() {
      currentMediaQuery = currentMediaQuery.copyWith(
        platformBrightness:
            currentMediaQuery.platformBrightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
      );
    });
  }

  void _toggleHighContrast() {
    setState(() {
      currentMediaQuery = currentMediaQuery.copyWith(
        highContrast: !currentMediaQuery.highContrast,
      );
    });
  }

  void _toggleInvertColors() {
    setState(() {
      currentMediaQuery = currentMediaQuery.copyWith(
        invertColors: !currentMediaQuery.invertColors,
      );
    });
  }

  void _textScaleFactorChanged(double value) {
    setState(() {
      currentMediaQuery = currentMediaQuery.copyWith(
        textScaleFactor: value,
      );
    });
  }

  void _toggleAnimations() {
    setState(() {
      currentMediaQuery = currentMediaQuery.copyWith(
        disableAnimations: !currentMediaQuery.disableAnimations,
      );
    });
  }

  void _devicePixelRatioChanged(double value) {
    setState(() {
      currentMediaQuery = currentMediaQuery.copyWith(
        devicePixelRatio: value,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentMediaQuery == null) {
      currentMediaQuery =
          MediaQuery.of(context).copyWith(size: currentDeviceSelected.size);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(8.0),
          )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              AdjustableNumberScaleWidget(
                scaleFactor: currentMediaQuery.devicePixelRatio,
                scaleFactorChanged: _devicePixelRatioChanged,
                displayIcon: Icons.aspect_ratio,
              ),
              IconButton(
                icon: Icon(currentMediaQuery.disableAnimations
                    ? Icons.directions_walk
                    : Icons.directions_run),
                tooltip: 'Toggle Animations',
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
                tooltip: 'Invert Colors On / Off',
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
                tooltip: 'High Contrast On / Off',
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
              ),
              Container(
                height: 15,
                child: VerticalDivider(),
              ),
              IconButton(
                icon: Icon(
                    currentMediaQuery.platformBrightness == Brightness.light
                        ? Icons.brightness_7
                        : Icons.brightness_3),
                tooltip: 'Turn Brightness On / Off',
                onPressed: () {
                  _toggleBrightness();
                },
              ),
              Container(
                height: 15,
                child: VerticalDivider(),
              ),
              SizedBox(
                width: 15,
              ),
              MediaChooserButton(
                deviceSelected: (value) => _deviceSelected(context, value),
                selectedDevice: currentDeviceSelected,
              ),
              SizedBox(
                width: 15,
              ),
            ],
          ),
        ),
        Expanded(
          child: !widget.shouldScroll
              ? widget.base.isolatedCopy(
                  home: widget.builder(context, currentMediaQuery))
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Theme.of(context).accentColor),
                      ),
                      constraints: BoxConstraints.tight(
                          currentMediaQuery.size.boundedSize(context)),
                      child: widget.base.isolatedCopy(
                          home: widget.builder(context, currentMediaQuery)),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
