import 'package:class_demo/pages/audio_page.dart';
import 'package:class_demo/pages/hello_world_page.dart';
import 'package:class_demo/pages/images_page.dart';
import 'package:class_demo/pages/navigation_page.dart';
import 'package:class_demo/pages/navigation_page_2.dart';
import 'package:class_demo/pages/text_input_page.dart';
import 'package:class_demo/pages/video_page.dart';
import 'package:class_demo/utils/app_globals.dart';
import 'package:class_demo/utils/code_page_template.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

typedef RouteMeta = ({
  String route,
  Widget Function(BuildContext) widgetBuilder,
  String name,
  bool hidden,
});

final List<RouteMeta> meta = [
  (
    route: "/",
    name: "Home",
    widgetBuilder: (_) => const MyHomePage(title: "Flutter Demo Home Page"),
    hidden: false,
  ),
  (
    route: "/helloworld",
    name: "Hello World",
    widgetBuilder: (_) => const HelloWorldPage(),
    hidden: false,
  ),
  (
    route: "/helloworld/code",
    name: "Hello World Code",
    widgetBuilder: (_) => const CodePageTemplate(
      title: Text("Hello World Code"),
      page: "lib/pages/hello_world_page.dart",
    ),
    hidden: true,
  ),
  (
    route: "/navigation",
    name: "Navigation",
    widgetBuilder: (_) => const NavigationPage(),
    hidden: false,
  ),
  (
    route: "/navigation/code",
    name: "Navigation Code",
    widgetBuilder: (_) => const CodePageTemplate(
      title: Text("Navigation Code"),
      page: "lib/pages/navigation_page.dart",
    ),
    hidden: true,
  ),
  (
    route: "/navigation/2",
    name: "Navigation - Page 2",
    widgetBuilder: (_) => const NavigationPage2(),
    hidden: true,
  ),
  (
    route: "/navigation/2/code",
    name: "Navigation - Page 2 Code",
    widgetBuilder: (_) => const CodePageTemplate(
      title: Text("Navigation - Page 2 Code"),
      page: "lib/pages/navigation_page_2.dart",
    ),
    hidden: true,
  ),
  (
    route: "/textinput",
    name: "Text Input",
    widgetBuilder: (_) => const TextInputPage(),
    hidden: false,
  ),
  (
    route: "/textinput/code",
    name: "Text Input Code",
    widgetBuilder: (_) => const CodePageTemplate(
      title: Text("Text Input Code"),
      page: "lib/pages/text_input_page.dart",
    ),
    hidden: true,
  ),
  (
    route: "/images",
    name: "Images",
    widgetBuilder: (_) => const ImagesPage(),
    hidden: false,
  ),
  (
    route: "/images/code",
    name: "Images Code",
    widgetBuilder: (_) => const CodePageTemplate(
      title: Text("Images Code"),
      page: "lib/pages/images_page.dart",
    ),
    hidden: true,
  ),
  (
    route: "/audio",
    name: "Audio",
    widgetBuilder: (_) => const AudioPage(),
    hidden: false,
  ),
  (
    route: "/audio/code",
    name: "Audio Code",
    widgetBuilder: (_) => const CodePageTemplate(
      title: Text("Audio Code"),
      page: "lib/pages/audio_page.dart",
    ),
    hidden: true,
  ),
  (
    route: "/video",
    name: "Video",
    widgetBuilder: (_) => const VideoPage(),
    hidden: false,
  ),
  (
    route: "/video/code",
    name: "Video Code",
    widgetBuilder: (_) => const CodePageTemplate(
      title: Text("Video Code"),
      page: "lib/pages/video_page.dart",
    ),
    hidden: true,
  ),
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Setup syntax highlighting
  await Highlighter.initialize(["dart"]);
  final HighlighterTheme lightTheme = await HighlighterTheme.loadFromAssets([
    "assets/highlighter_light.json",
    "assets/highlighter_light_plus.json",
  ], TextStyle(fontFamily: "JetBrains Mono", color: Colors.blue));
  final HighlighterTheme darkTheme = await HighlighterTheme.loadFromAssets([
    "assets/highlighter_dark.json",
    "assets/highlighter_dark_plus.json",
  ], TextStyle(fontFamily: "JetBrains Mono", color: Colors.blue));

  // Add font licenses to registry
  // Inter font license
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks([
      "Inter Variable font",
    ], await rootBundle.loadString("fonts/inter/LICENSE.txt"));
  });
  // Jetbrains Mono font license
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks([
      "JetBrains Mono font",
    ], await rootBundle.loadString("fonts/jetbrains_mono/OFL.txt"));
  });

  // Execute app
  runApp(MyApp(lightTheme: lightTheme, darkTheme: darkTheme));
}

class MyApp extends StatelessWidget {
  final HighlighterTheme lightTheme;
  final HighlighterTheme darkTheme;
  const MyApp({super.key, required this.lightTheme, required this.darkTheme});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
          dynamicSchemeVariant: DynamicSchemeVariant.content,
        ),
        brightness: Brightness.light,
        fontFamily: "Inter",
      ),
      // TODO: Fix dark theme
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
          dynamicSchemeVariant: DynamicSchemeVariant.content,
        ),
        brightness: Brightness.dark,
        fontFamily: "Inter",
      ),
      themeMode: ThemeMode.light,
      builder: (context, child) {
        HighlighterTheme theme;
        if (MediaQuery.platformBrightnessOf(context) == Brightness.dark) {
          theme = darkTheme;
        } else {
          theme = lightTheme;
        }
        return AppGlobals(
          theme: theme,
          lightTheme: lightTheme,
          darkTheme: darkTheme,
          child: child ?? SizedBox.square(dimension: 0),
        );
      },
      initialRoute: meta.first.route,
      routes: meta.map((e) => {e.route: e.widgetBuilder}).reduce((
        value,
        element,
      ) {
        var newMap = value;
        newMap.addAll(element);
        return newMap;
      }),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    var renderList = meta.sublist(1).where((r) => !r.hidden).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: "Class Demo",
                // applicationIcon: FlutterLogo(),
                applicationLegalese:
                    "All rights reserved by author(s), unless stated otherwise.",
                applicationVersion:
                    "1.0.0, using Flutter ${FlutterVersion.version} & Dart ${FlutterVersion.dartVersion}",
              );
            },
            icon: Icon(Icons.info),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: 180),
          child: Column(
            spacing: 4,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List<Widget>.generate(
              renderList.length,
              (index) => FilledButton(
                onPressed: () async {
                  await Navigator.of(
                    context,
                  ).pushNamed(renderList[index].route);
                },
                child: Text(renderList[index].name),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
