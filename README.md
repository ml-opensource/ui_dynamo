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
void main() => runApp(AppStoryBook());

class AppDynamo extends StatelessWidget {
  const AppDynamo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dynamo.withApp(
      buildApp(),
    );
  }
}
```

### Add your Dynamo data

By default, UIDynamo 
