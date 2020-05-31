import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/localization/locale_chooser.dart';
import 'package:flutter_storybook/media_utils.dart';
import 'package:flutter_storybook/mediaquery/device_sizes.dart';
import 'package:flutter_storybook/mediaquery/offset_plugin.dart';
import 'package:flutter_storybook/mediaquery/override_media_query_plugin.dart';
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

  void _deviceSelected(
      BuildContext context,
      DeviceInfo device,
      OverrideMediaQueryProvider mediaQueryProvider,
      MediaQueryData realQuery,
      OffsetProvider offsetProvider) {
    // reset scale, offset back to 100% when changing device
    if (device != mediaQueryProvider.currentDevice) {
      mediaQueryProvider.resetScreenAdjustments(
        offsetProvider,
        newDevice: device,
        overrideData: mediaQueryProvider.currentMediaQuery.copyWith(
          size: device.logicalSize.boundedSize(context),
        ),
        realQuery: realQuery,
        overrideOrientation: device.isExpandable ? Orientation.portrait : null,
        shouldFlip: !device.isExpandable &&
            mediaQueryProvider.orientation == Orientation.landscape,
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

  void _updateScale(double scale, OffsetProvider provider) {
    provider.selectScreenScale(scale);
  }

  List<Widget> topBarList(OverrideMediaQueryProvider mediaQueryProvider,
      MediaQueryData realQuery, OffsetProvider offsetProvider) {
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
      _MediaQueryDivider(),
      IconButton(
        tooltip: 'Size to Fit',
        icon: Icon(Icons.center_focus_strong),
        onPressed: () => mediaQueryProvider
            .resetScreenAdjustments(offsetProvider, realQuery: realQuery),
      ),
      _MediaQueryDivider(),
      IconButton(
        tooltip: !mediaQueryProvider.currentDevice.isExpandable
            ? "Rotate"
            : "Rotate not available for expandable windows.",
        icon: Icon(mediaQueryProvider.orientation == Orientation.portrait
            ? Icons.screen_lock_portrait
            : Icons.screen_lock_landscape),
        onPressed: !mediaQueryProvider.currentDevice.isExpandable
            ? () => mediaQueryProvider.rotate(context)
            : null,
      ),
      _MediaQueryDivider(),
      LocaleChooser(),
    ];
  }

  buildIcons(
      BuildContext context,
      OverrideMediaQueryProvider mediaQueryProvider,
      OffsetProvider offsetProvider) {
    final expandable = context.isMobile;
    final realQuery = MediaQuery.of(context);
    if (expandable && !isExpanded) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ...topBarList(mediaQueryProvider, realQuery, offsetProvider)
        ],
      );
    }
    final currentMediaQuery = mediaQueryProvider.currentMediaQuery;
    return Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        ...topBarList(mediaQueryProvider, realQuery, offsetProvider),
        _MediaQueryDivider(),
        AdjustableNumberScaleWidget(
          scaleFactor: currentMediaQuery.textScaleFactor,
          scaleFactorChanged: (value) =>
              _textScaleFactorChanged(value, mediaQueryProvider),
          displayIcon: Icons.text_fields,
          tooltip: 'Select a Text Scale',
        ),
        _MediaQueryDivider(),
        MediaChooserButton(
          deviceSelected: (value) => _deviceSelected(
              context, value, mediaQueryProvider, realQuery, offsetProvider),
          selectedDevice: mediaQueryProvider.currentDevice,
        ),
        if (!mediaQueryProvider.currentDevice.isExpandable) ...[
          ZoomControls(
            scale: offsetProvider.screenScale,
            updateScale: (value) => _updateScale(value, offsetProvider),
          ),
          _AnimationsIcon(
            currentMediaQuery: currentMediaQuery,
            toggle: () => _toggleAnimations(mediaQueryProvider),
          ),
          _MediaQueryDivider(),
          _InvertColorsButton(
            currentMediaQuery: currentMediaQuery,
            toggle: () => _toggleInvertColors(mediaQueryProvider),
          ),
          _MediaQueryDivider(),
          _HighContrastIcon(
            currentMediaQuery: currentMediaQuery,
            toggle: () => _toggleHighContrast(mediaQueryProvider),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardmargin = context.isTablet
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
              child: buildIcons(context, media, context.offsetProvider),
            ),
            if (context.isMobile)
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

class _MediaQueryDivider extends StatelessWidget {
  const _MediaQueryDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      child: VerticalDivider(),
    );
  }
}

abstract class _ToggleIcon extends StatelessWidget {
  final GestureTapCallback toggle;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;

  const _ToggleIcon(
      {Key key,
      @required this.toggle,
      @required this.activeIcon,
      @required this.inactiveIcon,
      @required this.label})
      : super(key: key);

  bool get isActivated;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isActivated ? activeIcon : inactiveIcon,
      ),
      tooltip: '$label ' + (isActivated ? 'Off' : 'On'),
      onPressed: toggle,
    );
  }
}

class _HighContrastIcon extends _ToggleIcon {
  final MediaQueryData currentMediaQuery;
  final GestureTapCallback toggle;

  const _HighContrastIcon({Key key, this.currentMediaQuery, this.toggle})
      : super(
            key: key,
            toggle: toggle,
            activeIcon: Icons.tonality,
            inactiveIcon: Icons.panorama_fish_eye,
            label: 'High Contrast');

  @override
  bool get isActivated => currentMediaQuery.highContrast;
}

class _InvertColorsButton extends _ToggleIcon {
  final MediaQueryData currentMediaQuery;
  final GestureTapCallback toggle;

  const _InvertColorsButton({Key key, this.currentMediaQuery, this.toggle})
      : super(
            key: key,
            toggle: toggle,
            activeIcon: Icons.invert_colors,
            inactiveIcon: Icons.invert_colors_off,
            label: 'Invert Colors');

  @override
  bool get isActivated => currentMediaQuery.invertColors;
}

class _AnimationsIcon extends _ToggleIcon {
  final MediaQueryData currentMediaQuery;
  final GestureTapCallback toggle;

  const _AnimationsIcon({Key key, this.currentMediaQuery, this.toggle})
      : super(
            key: key,
            toggle: toggle,
            activeIcon: Icons.directions_walk,
            inactiveIcon: Icons.directions_run,
            label: 'Toggle Animations');

  @override
  bool get isActivated => !currentMediaQuery.disableAnimations;
}
