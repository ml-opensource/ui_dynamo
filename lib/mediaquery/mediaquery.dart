import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  DeviceInfo currentDeviceSelected = deviceSizes.values.toList()[0];

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
              TextScaleFactorWidget(
                textScaleFactor: currentMediaQuery.textScaleFactor,
                textScaleFactorChanged: _textScaleFactorChanged,
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

enum DeviceCategory { Mobile, Tablet, Desktop, Expand }

class DeviceInfo {
  final String name;
  final Size size;
  final DeviceCategory category;

  const DeviceInfo(this.name, this.size, this.category);

  IconData get iconForCategory {
    switch (category) {
      case DeviceCategory.Desktop:
        return Icons.desktop_mac;
      case DeviceCategory.Tablet:
        return Icons.tablet_mac;
      case DeviceCategory.Expand:
        return Icons.settings_ethernet;
      case DeviceCategory.Mobile:
      default:
        return Icons.smartphone;
    }
  }
}

const Map<String, DeviceInfo> deviceSizes = {
  'Device Window Size':
      DeviceInfo('Window', Size.infinite, DeviceCategory.Expand),
  'iPhone 5': DeviceInfo('iPhone 5', Size(320, 568), DeviceCategory.Mobile),
  'iPhone 6': DeviceInfo('iPhone 6', Size(375, 667), DeviceCategory.Mobile),
  'iPhone 6/7/8 Plus':
      DeviceInfo('iPhone 6/7/8 Plus', Size(414, 736), DeviceCategory.Mobile),
  'iPhone X': DeviceInfo('iPhone X', Size(375, 812), DeviceCategory.Mobile),
  'iPhone XR/XS Max':
      DeviceInfo('iPhone XR/XS Max', Size(414, 896), DeviceCategory.Mobile),
  'iPad': DeviceInfo('iPad', Size(768, 1024), DeviceCategory.Tablet),
  'iPad Pro 10.5-in':
      DeviceInfo('iPad Pro 10.5-in', Size(834, 1112), DeviceCategory.Tablet),
  'iPad Pro 12.9-in':
      DeviceInfo('iPad Pro 12.9-in', Size(1024, 1366), DeviceCategory.Tablet),
  'Galaxy S5': DeviceInfo('Galaxy S5', Size(360, 640), DeviceCategory.Mobile),
  'Galaxy S9': DeviceInfo('Galaxy S9', Size(720, 1460), DeviceCategory.Mobile),
  'Nexus 5X': DeviceInfo('Nexus 5X', Size(412, 660), DeviceCategory.Mobile),
  'Nexus 6P': DeviceInfo('Nexus 6P', Size(412, 732), DeviceCategory.Mobile),
  'Pixel': DeviceInfo('Pixel', Size(540, 960), DeviceCategory.Mobile),
  'Pixel XL': DeviceInfo('Pixel XL', Size(720, 1280), DeviceCategory.Mobile),
};
