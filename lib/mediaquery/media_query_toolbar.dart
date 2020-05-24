import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/media_utils.dart';
import 'package:flutter_storybook/mediaquery/device_sizes.dart';
import 'package:flutter_storybook/mediaquery/override_media_query_provider.dart';
import 'package:flutter_storybook/mediaquery/screen_size_chooser.dart';
import 'package:flutter_storybook/mediaquery/text_scale.dart';
import 'package:flutter_storybook/mediaquery/zoom_controls.dart';
import 'package:flutter_storybook/ui/utils/size+extensions.dart';
import 'package:flutter_storybook/ui/widgets/measuresize.dart';

class MediaQueryToolbar extends StatefulWidget {
  const MediaQueryToolbar({
    Key key,
  }) : super(key: key);

  @override
  _MediaQueryToolbarState createState() => _MediaQueryToolbarState();
}

class _MediaQueryToolbarState extends State<MediaQueryToolbar> {
  bool isExpanded = false;

  void _deviceSelected(BuildContext context, DeviceInfo device,
      OverrideMediaQueryProvider mediaQueryProvider, MediaQueryData realQuery) {
    // reset scale, offset back to 100% when changing device
    if (device != mediaQueryProvider.currentDevice) {
      mediaQueryProvider.resetScreenAdjustments(
        newDevice: device,
        overrideData: mediaQueryProvider.currentMediaQuery.copyWith(
          size: device.logicalSize.boundedSize(context),
        ),
        realQuery: realQuery,
      );
    }
  }

  void _toggleBrightness(OverrideMediaQueryProvider mediaQueryProvider) {
    mediaQueryProvider
        .selectMediaQuery(mediaQueryProvider.currentMediaQuery.copyWith(
      platformBrightness:
          mediaQueryProvider.currentMediaQuery.platformBrightness ==
                  Brightness.light
              ? Brightness.dark
              : Brightness.light,
    ));
  }

  void _toggleHighContrast(OverrideMediaQueryProvider mediaQueryProvider) {
    mediaQueryProvider
        .selectMediaQuery(mediaQueryProvider.currentMediaQuery.copyWith(
      highContrast: !mediaQueryProvider.currentMediaQuery.highContrast,
    ));
  }

  void _toggleInvertColors(OverrideMediaQueryProvider mediaQueryProvider) {
    mediaQueryProvider
        .selectMediaQuery(mediaQueryProvider.currentMediaQuery.copyWith(
      invertColors: !mediaQueryProvider.currentMediaQuery.invertColors,
    ));
  }

  void _textScaleFactorChanged(
      double value, OverrideMediaQueryProvider mediaQueryProvider) {
    mediaQueryProvider
        .selectMediaQuery(mediaQueryProvider.currentMediaQuery.copyWith(
      textScaleFactor: value,
    ));
  }

  void _toggleAnimations(OverrideMediaQueryProvider mediaQueryProvider) {
    mediaQueryProvider
        .selectMediaQuery(mediaQueryProvider.currentMediaQuery.copyWith(
      disableAnimations:
          !mediaQueryProvider.currentMediaQuery.disableAnimations,
    ));
  }

  void _updateScale(
      double scale, OverrideMediaQueryProvider mediaQueryProvider) {
    mediaQueryProvider.selectScreenScale(scale);
  }

  Widget buildDivider() => Container(
        height: 15,
        child: VerticalDivider(),
      );

  List<Widget> topBarList(
      OverrideMediaQueryProvider mediaQueryProvider, MediaQueryData realQuery) {
    return [
      IconButton(
        icon: Icon(mediaQueryProvider.currentMediaQuery.platformBrightness ==
                Brightness.light
            ? Icons.brightness_7
            : Icons.brightness_3),
        tooltip: 'Make Brightness ' +
            (mediaQueryProvider.currentMediaQuery.platformBrightness ==
                    Brightness.light
                ? 'Dark'
                : 'Light'),
        onPressed: () {
          _toggleBrightness(mediaQueryProvider);
        },
      ),
      buildDivider(),
      IconButton(
        tooltip: 'Size to Fit',
        icon: Icon(Icons.center_focus_strong),
        onPressed: () =>
            mediaQueryProvider.resetScreenAdjustments(realQuery: realQuery),
      ),
      buildDivider(),
      IconButton(
        tooltip: mediaQueryProvider.currentDevice != DeviceSizes.window
            ? "Rotate"
            : "Rotate not available for window sizing.",
        icon: Icon(mediaQueryProvider.orientation == Orientation.portrait
            ? Icons.screen_lock_portrait
            : Icons.screen_lock_landscape),
        onPressed: mediaQueryProvider.currentDevice != DeviceSizes.window
            ? () => mediaQueryProvider.rotate(context)
            : null,
      ),
    ];
  }

  buildIcons(
      BuildContext context, OverrideMediaQueryProvider mediaQueryProvider) {
    final expandable = isMobile(context);
    final realQuery = MediaQuery.of(context);
    if (expandable && !isExpanded) {
      return Wrap(
        children: [...topBarList(mediaQueryProvider, realQuery)],
      );
    }
    return Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        ...topBarList(mediaQueryProvider, realQuery),
        buildDivider(),
        AdjustableNumberScaleWidget(
          scaleFactor: mediaQueryProvider.currentMediaQuery.textScaleFactor,
          scaleFactorChanged: (value) =>
              _textScaleFactorChanged(value, mediaQueryProvider),
          displayIcon: Icons.text_fields,
          tooltip: 'Select a Text Scale',
        ),
        buildDivider(),
        MediaChooserButton(
          deviceSelected: (value) =>
              _deviceSelected(context, value, mediaQueryProvider, realQuery),
          selectedDevice: mediaQueryProvider.currentDevice,
        ),
        if (mediaQueryProvider.currentDevice != DeviceSizes.window) ...[
          ZoomControls(
            scale: mediaQueryProvider.screenScale,
            updateScale: (value) => _updateScale(value, mediaQueryProvider),
          ),
          IconButton(
            icon: Icon(mediaQueryProvider.currentMediaQuery.disableAnimations
                ? Icons.directions_walk
                : Icons.directions_run),
            tooltip: 'Toggle Animations ' +
                (mediaQueryProvider.currentMediaQuery.disableAnimations
                    ? 'On'
                    : 'Off'),
            onPressed: () => _toggleAnimations(mediaQueryProvider),
          ),
          buildDivider(),
          IconButton(
            icon: Icon(
              mediaQueryProvider.currentMediaQuery.invertColors
                  ? Icons.invert_colors
                  : Icons.invert_colors_off,
            ),
            tooltip: 'Invert Colors ' +
                (mediaQueryProvider.currentMediaQuery.invertColors
                    ? 'Off'
                    : 'On'),
            onPressed: () => _toggleInvertColors(mediaQueryProvider),
          ),
          buildDivider(),
          IconButton(
            icon: Icon(
              mediaQueryProvider.currentMediaQuery.highContrast
                  ? Icons.tonality
                  : Icons.panorama_fish_eye,
            ),
            tooltip: 'High Contrast ' +
                (mediaQueryProvider.currentMediaQuery.highContrast
                    ? 'Off'
                    : 'On'),
            onPressed: () => _toggleHighContrast(mediaQueryProvider),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardmargin = isTablet(context)
        ? EdgeInsets.only(left: 4.0, right: 4.0)
        : EdgeInsets.all(0);
    final media = context.mediaQueryProvider;
    return Builder(
      builder: (context) => Card(
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
              child: buildIcons(context, media),
            ),
            if (isMobile(context))
              SizedBox(
                width: 48,
                height: 48,
                child: InkWell(
                  borderRadius: BorderRadius.circular(96.0),
                  child:
                      Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                      MeasureSizeProvider.of(context)?.notifySizeChange();
                    });
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}
