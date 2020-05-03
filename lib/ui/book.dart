import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/actions/actions_extensions.dart';
import 'package:flutter_storybook/flutter_storybook.dart';
import 'package:flutter_storybook/mediaquery/mediaquery.dart';
import 'package:flutter_storybook/models.dart';
import 'package:flutter_storybook/props/props_extensions.dart';
import 'package:flutter_storybook/ui/drawer.dart';
import 'package:flutter_storybook/ui/toolbar.dart';
import 'package:flutter_storybook/ui/widgets/page.dart';
import 'package:flutter_storybook/ui/widgets/storyboard.dart';
import 'package:provider/provider.dart';

class StoryBook extends StatefulWidget {
  final StoryBookData data;
  final MaterialApp app;

  factory StoryBook.withApp(MaterialApp app, {@required StoryBookData data}) =>
      StoryBook(
        app: app,
        data: data.merge(items: [
          storyboard(app, title: 'Storyboard'),
          StoryBookFolder.of(
            title: 'Routes',
            pages: [
              ...app.routes.entries.map((entry) =>
                  StoryBookPage.of(title: entry.key, child: entry.value)),
            ],
          ),
        ]),
      );

  const StoryBook({Key key, @required this.data, @required this.app})
      : super(key: key);

  @override
  _StoryBookState createState() => _StoryBookState();
}

class _StoryBookState extends State<StoryBook> {
  Key _selectedFolderKey;
  Key _selectedPageKey;
  bool isDrawerOpen = false;

  StoryBookPage selectedPageFromWidget() {
    if (_selectedFolderKey != null && _selectedPageKey != null) {
      final folder = widget.data.items.firstWhere(
          (element) => element.key == _selectedFolderKey,
          orElse: () => null);
      if (folder != null) {
        return folder.pageFromKey(_selectedPageKey);
      }
    }
    return null;
  }

  void _selectPage(
      StoryBookPage page, StoryBookItem folder, BuildContext context) {
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
    return MaterialApp(
      theme: widget.app.theme,
      darkTheme: widget.app.darkTheme,
      debugShowCheckedModeBanner: widget.app.debugShowCheckedModeBanner,
      themeMode: widget.app.themeMode,
      home: MultiProvider(
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
              onSelectPage: (folder, page) =>
                  _selectPage(page, folder, context),
            ),
          ),
          resizeToAvoidBottomPadding: true,
          bottomNavigationBar: selectedPage.usesToolbar ? ToolbarPane() : null,
          body: (selectedPage != null)
              ? StoryBookPageWrapperWidget(selectedPage: selectedPage)
              : _StoryBookHomePage(),
        ),
      ),
    );
  }
}

class StoryBookPageWrapperWidget extends StatelessWidget {
  const StoryBookPageWrapperWidget({
    Key key,
    @required this.selectedPage,
  }) : super(key: key);

  final StoryBookPage selectedPage;

  @override
  Widget build(BuildContext context) {
    return MediaQueryChooser(
      shouldScroll: selectedPage.shouldScroll,
      builder: (context, data) => selectedPage.build(context, data),
    );
  }
}

class _StoryBookHomePage extends StatelessWidget {
  const _StoryBookHomePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQueryChooser.mediaQuery(
      builder: (context) => Padding(
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
