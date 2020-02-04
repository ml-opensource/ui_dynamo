import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/actions/actions_extensions.dart';
import 'package:flutter_storybook/mediaquery/mediaquery.dart';
import 'package:flutter_storybook/models.dart';
import 'package:flutter_storybook/props/props_extensions.dart';
import 'package:flutter_storybook/ui/drawer.dart';
import 'package:flutter_storybook/ui/toolbar.dart';
import 'package:provider/provider.dart';

class StoryBook extends StatefulWidget {
  final StoryBookData data;

  const StoryBook({Key key, @required this.data}) : super(key: key);

  @override
  _StoryBookState createState() => _StoryBookState();
}

class _StoryBookState extends State<StoryBook> {
  Key _selectedFolderKey;
  Key _selectedPageKey;
  bool isDrawerOpen = false;

  StoryBookPage selectedPageFromWidget() {
    if (_selectedFolderKey != null && _selectedPageKey != null) {
      final folder = widget.data.folders.firstWhere(
          (element) => element.key == _selectedFolderKey,
          orElse: () => null);
      if (folder != null) {
        return folder.pages.firstWhere(
            (element) => element.key == _selectedPageKey,
            orElse: () => null);
      }
    }
    return null;
  }

  void _selectPage(
      StoryBookPage page, StoryBookFolder folder, BuildContext context) {
    setState(() {
      _selectedPageKey = page.key;
      _selectedFolderKey = folder.key;
      props(context).reset();
      actions(context).reset();
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedPage = selectedPageFromWidget();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ActionsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PropsProvider(),
        )
      ],
      child: Scaffold(
        appBar: AppBar(
          title: selectedPage != null ? selectedPage.title : Text('Home'),
        ),
        drawer: Builder(
          builder: (context) => StoryBookDrawer(
            data: widget.data,
            selectedPage: selectedPage,
            onSelectPage: (folder, page) => _selectPage(page, folder, context),
          ),
        ),
        resizeToAvoidBottomPadding: true,
        bottomNavigationBar: ToolbarPane(),
        body: (selectedPage != null)
            ? StoryBookPageWidget(selectedPage: selectedPage)
            : _StoryBookHomePage(),
      ),
    );
  }
}

class StoryBookPageWidget extends StatelessWidget {
  const StoryBookPageWidget({
    Key key,
    @required this.selectedPage,
  }) : super(key: key);

  final StoryBookPage selectedPage;

  @override
  Widget build(BuildContext context) {
    return MediaQueryChooser(
      child: Expanded(
        child: Builder(
          builder: (context) => Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: ListView(
              children: <Widget>[
                ...selectedPage.widgets.map((e) => Column(
                      children: <Widget>[
                        SizedBox(
                          height: 16.0,
                        ),
                        e.childBuilder(context),
                      ],
                    )),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StoryBookHomePage extends StatelessWidget {
  const _StoryBookHomePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQueryChooser(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.book,
                size: 100,
                color: Colors.deepPurple,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Welcome to Flutter Storybook. ',
                style: TextStyle(fontSize: 30),
              ),
              Text.rich(
                TextSpan(children: [
                  TextSpan(text: 'Click on a '),
                  WidgetSpan(child: Icon(Icons.folder)),
                  TextSpan(text: ' to select a page to preview.')
                ]),
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
