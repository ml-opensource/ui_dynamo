# UIDynamo

UIDynamo is a development companion for developing UI components in isolation, 
increasing developer productivity exponentially. 

__Documentation__: Create beautiful documentation for your components all in Flutter. The app is just a platform application 
that you can distribute anywhere for your team to interact with.

__Storyboarding__: Storyboard all of your app screens at once in a pan and zoom environment, or create custom routing flows 
to enable easy iteration.

__Device Toolbar__: Preview anything in this tool in light mode / dark mode, different languages, screen rotation, 
different display sizes, and more.

__Flexibility__: use this tool on your smartphone, tablet, desktop (mac), web browser (chrome), or wherever Flutter can run. 
More platforms will be on the way. Dynamo themes automatically to your application, but feel free 
to use Material theming to adjust the look and feel.

__Props__: use the props editor to see changes to your components live within the documentation. 

__Actions__: use actions to display logs of component actions.

__Localizations__: display translations for your application and see them in different languages. 

__Plugins__: Add plugins to appear in the plugins bar, or behind the scenes, to provide greater flexibility in your workflow.

![Preview](/assets/preview.png)


## Getting Started

There are two ways to add the library to your project.

### Project Dependency 

Adding the library as a project dependency will place it within your code as a library.

Add this line to your pubspec.yaml to add the library:

```yaml
dependencies:
    ui_dynamo: "xx.xx.xx"
```

Replace with current version.

Add a folder in your project called `dynamo`. Place a `main.dart` file 
that you will run UIDynamo from. In your IDE add the file as a run configuration, separating Dynamo from your 
main application.

### Separate Project

You can, alternatively, create a new flutter module that depends on your main application. This way 
you can isolate Dynamo completely from your application code. 

Add a module called `dynamo`.

Add this line to your pubspec.yaml  in the `dynamo` module:

```yaml
dependencies:
    ui_dynamo: "xx.xx.xx"
    app:
      path: ../ # or application path
```

### Setting up UIDynamo

In your main `lib/main.dart` of your application, adjust your App component to export its `MaterialApp` as 
a function:

```dart
MaterialApp buildApp() => MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
```

This is needed to use the main app in `dynamo`.

In your `dynamo/main.dart`, first add the run configuration and `AppDynamo`:

```dart
void main() => runApp(AppDynamo());

class AppDynamo extends StatelessWidget {
  const AppDynamo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dynamo.withApp(
      buildApp(),
      data: DynamoData(
        defaultDevice: DeviceSizes.iphoneX,
      ),
    );
  }
}
```

### Add your Dynamo data

By default, UIDynamo will traverse your application routes, creating a 
`Storyboard` and `Routes/` folder in the nav bar. `Home` is just a placeholder (and configureable).

![Default Setup](/assets/default_setup.png)

You can add 3 kinds of items in the sidebar:

1. __Storyboard__: A pinch-zoom and pannable experience that allows you to easily add custom flows within your application all 
on one screen.

```dart
DynamoPage.storyBoard(title: 'Your Title', flowMapping: {
   'home': [
    '/home',
    '/company'
   ]
});
```

__flowMapping__ a key-value-list mapping that specifies flows that display on screen from left to right.
If you specify multiple, each mapping goes from top to bottom in order. 

![Storyboard Example](/assets/storyboard_example.png)


2. __Folder__: A collapsible section that contains more items. Can nest as many as you like.

```dart
DynamoFolder.of(title: 'Widgets', pages: [
    buildTextStylePage(),
    buildButtonsPage(),
    buildToastPage(),
    buildRadiosPage(),
    buildInputsPage(),
]);
```

![Folder Example](/assets/folder_example.png)

3. __Page__: A single, focusable page that you can preview.

Simplest builder is:

```dart
DynamoPage.of(
    title: 'Title',
    icon: Icon(Icons.home),
    child: (context) =>
        MyWidget(),
);
```

Specify the `title`, `icon`, and `child` builder. The child builder only runs if you the widget is on screen.

Also we support a list:

```dart
DynamoPage.list(
  title: 'Alerts',
  icon: Icon(Icons.error),
  children: (context) => [
    Organization.container(
      title: Text('Network Alert'),
      children: <Widget>[
        NetworkAlertDialog(
          onOkPressed: context.actions.onPressed('Alert Ok Button'),
        ),
      ],
    ),
    Organization.container(
      title: Text('Confirmation Dialog'),
      children: <Widget>[
        ConfirmationAlertDialog(
          title: context.props.text(
              'Title', 'Are you sure you want to get Pizza?',
              group: confirmationGroup),
          content: context.props.text(
              'Content', 'You can always order later',
              group: confirmationGroup),
          onYesPressed: context.actions.onPressed('Alert Yes Button'),
          onNoPressed: context.actions.onPressed('Alert No Button'),
        ),
      ],
    )
  ],
)
```

`title`, `icon`, and `children` builder. The `children` builder only is used when on screen as well. 

The list builder just displays content in a list.


## Storyboard Configuration

## UI Documentation

## Adding Props

## Configuring Actions

## Localizations

## Custom Plugins  


## Maintainers

Andrew Grosner [@agrosner](https://www.github.com/agrosner)

