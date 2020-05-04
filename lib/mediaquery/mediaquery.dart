import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/ui/materialapp+extensions.dart';

typedef MediaWidgetBuilder = Widget Function(BuildContext, MediaQueryData);

class MediaQueryChooser extends StatefulWidget {
  final MediaWidgetBuilder builder;
  final bool shouldScroll;
  final MaterialApp base;

  const MediaQueryChooser(
      {Key key, @required this.builder, this.shouldScroll = true,
        @required this.base})
      : super(key: key);

  factory MediaQueryChooser.mediaQuery({
    WidgetBuilder builder,
    MaterialApp base
  }) =>
      MediaQueryChooser(
        builder: (context, data) =>
            MediaQuery(data: data, child: builder(context)),
        base: base,
      );

  @override
  _MediaQueryChooserState createState() => _MediaQueryChooserState();
}

String deviceDisplay(String key, Size deviceSize) =>
    "$key (${deviceSize.width.truncate()}x${deviceSize.height.truncate()})";

class _MediaQueryChooserState extends State<MediaQueryChooser> {
  MediaQueryData currentMediaQuery;
  String currentDeviceSelected;

  void _deviceSelected(String name) {
    final device = deviceSizes[name];
    setState(() {
      currentDeviceSelected = name == '' ? null : name; // reset if blank
      currentMediaQuery = name != ''
          ? MediaQueryData(
              size: device,
            )
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentMediaQuery == null) {
      currentMediaQuery = MediaQuery.of(context);
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
              if (currentDeviceSelected != null)
                Text(deviceDisplay(
                    currentDeviceSelected, deviceSizes[currentDeviceSelected])),
              MediaChooserButton(
                deviceSelected: _deviceSelected,
                selectedDeviceName: currentDeviceSelected,
              ),
            ],
          ),
        ),
        Expanded(
          child: !widget.shouldScroll
              ? widget.base.isolatedCopy(home: widget.builder(context, currentMediaQuery))
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: currentDeviceSelected != null
                          ? BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).accentColor),
                            )
                          : null,
                      constraints: BoxConstraints.tight(currentMediaQuery.size),
                      child: widget.base.isolatedCopy(home: widget.builder(context, currentMediaQuery)),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

const Map<String, Size> deviceSizes = {
  'iPhone 5': Size(320, 568),
  'iPhone 6': Size(375, 667),
  'iPhone 6/7/8 Plus': Size(414, 736),
  'iPhone X': Size(375, 812),
  'iPhone XR/XS Max': Size(414, 896),
  'iPad': Size(768, 1024),
  'iPad Pro 10.5-in': Size(834, 1112),
  'iPad Pro 12.9-in': Size(1024, 1366),
  'Galaxy S5': Size(360, 640),
  'Galaxy S9': Size(720, 1460),
  'Nexus 5X': Size(412, 660),
  'Nexus 6P': Size(412, 732),
  'Pixel': Size(540, 960),
  'Pixel XL': Size(720, 1280),
};

class MediaChooserButton extends StatelessWidget {
  final Function(String) deviceSelected;
  final String selectedDeviceName;

  const MediaChooserButton({
    Key key,
    @required this.deviceSelected,
    @required this.selectedDeviceName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.view_list,
        color: Theme.of(context).iconTheme.color,
      ),
      onSelected: deviceSelected,
      itemBuilder: (BuildContext context) => [
        CheckedPopupMenuItem(
          checked: selectedDeviceName == null,
          value: '',
          child: Row(
            children: <Widget>[
              Text(
                'Device Window Size',
                style: TextStyle(fontSize: 12.0),
              ),
            ],
          ),
        ),
        ...deviceSizes.keys.map(
          (key) => buildDeviceOption(key, deviceSizes[key], selectedDeviceName),
        ),
      ],
    );
  }

  PopupMenuItem<String> buildDeviceOption(
      String key, Size deviceSize, String selectedDeviceName) {
    return CheckedPopupMenuItem(
      checked: selectedDeviceName == key,
      value: key,
      child: Text(
        deviceDisplay(key, deviceSize),
        style: TextStyle(fontSize: 12.0),
      ),
    );
  }
}
