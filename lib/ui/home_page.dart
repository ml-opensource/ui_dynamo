import 'package:flutter/material.dart';
import 'package:flutter_storybook/media_utils.dart';
import 'package:flutter_storybook/mediaquery/media_query_toolbar.dart';
import 'package:flutter_storybook/models.dart';
import 'package:flutter_storybook/ui/drawer/drawer.dart';
import 'package:flutter_storybook/ui/drawer/drawer_provider.dart';
import 'package:flutter_storybook/ui/model/page.dart';

class StoryBookHomePage extends StatelessWidget {
  final StoryBookData data;

  const StoryBookHomePage({
    Key key,
    @required this.data,
  }) : super(key: key);

  void _selectPage(
      StoryBookPage page, StoryBookItem folder, BuildContext context) {
    context.drawerProvider
        .select(context, folder.key, page.key, popDrawer: true);
  }

  buildRoutesListing(StoryBookPage selectedPage, BuildContext context,
          StoryBookData data) =>
      Row(
        children: [
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: 500),
              child: Card(
                margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: RoutesList(
                  shrinkWrap: true,
                  data: data,
                  selectedPage: selectedPage,
                  onSelectPage: (folder, page) =>
                      _selectPage(page, folder, context),
                ),
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final selectedPage = selectedPageFromWidget(data, context);
    final watch = isWatch(context);
    final padding = watch ? 8.0 : 32.0;
    return Container(
      padding: EdgeInsets.only(left: padding, right: padding),
      alignment: AlignmentDirectional.center,
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 32,
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16.0,
            runSpacing: 16.0,
            children: [
              Icon(
                Icons.book,
                size: 50,
              ),
              Text(
                'Welcome to Flutter Storybook. ',
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Text.rich(
            TextSpan(children: [
              TextSpan(text: 'Start with the storyboard '),
              WidgetSpan(child: Icon(Icons.book)),
              TextSpan(text: ' to view your whole app on one screen.')
            ]),
            style: TextStyle(fontSize: 20),
          ),
          buildRoutesListing(selectedPage, context,
              data.copyWith(items: data.items.sublist(0, 1))),
          SizedBox(
            height: 16,
          ),
          Text.rich(
            TextSpan(children: [
              TextSpan(text: ' Select a '),
              WidgetSpan(child: Icon(Icons.folder)),
              TextSpan(text: ' to pick a page to preview.'),
              TextSpan(text: ' The drawer '),
              WidgetSpan(child: Icon(Icons.menu)),
              TextSpan(text: ' also contains the same.')
            ]),
            style: TextStyle(fontSize: 20),
          ),
          buildRoutesListing(selectedPage, context,
              data.copyWith(items: data.items.sublist(1))),
          SizedBox(
            height: 16,
          ),
          Text(
            '3. Utilize the toolbar at the top to change MediaQueryData passed '
            'down to the rendered screens. Each page in the storybook / storyboard is a '
            'separate app experience.',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Flexible(
                child: MediaQueryToolbar(),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            '4. Utilize Props to preview test data and experiment with '
            'how widgets get rendered. Utilize actions to quickly debug action '
            'streams.',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
