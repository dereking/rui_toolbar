import 'package:flutter/material.dart';
import 'package:rui_toolbar/rui_menu_item.dart';

import 'package:rui_toolbar/rui_toolbar.dart';
import 'package:rui_toolbar/enum.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  MenuButtonStyle buttonStyle = MenuButtonStyle.iconOnly;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Row(
        children: [
          _leftMenu(context),
          Expanded(child: _buildBody(context)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return RuiToolbar(
      buttonStyle: buttonStyle,
      items: [
        RuiMenuItem(id: '1', icon: Icons.home, title: 'Home'),
        RuiMenuItem(
          id: '2',
          icon: Icons.settings,
          title: 'Settings',
          subItems: [
            RuiMenuItem(id: '2-1', icon: Icons.settings, title: 'Sound'),
            RuiMenuItem(id: '2-2', icon: Icons.settings, title: 'Movie'),
          ],
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _buildTopBar(context),
        _buildMenuSetting(context),
        const Text('You have pushed the button this many times:'),
        Text('$_counter', style: Theme.of(context).textTheme.headlineMedium),
      ],
    );
  }

  Widget _buildButtonStyleCheckbox(
    MenuButtonStyle s,
    String txt,
    void Function(bool?) onChanged,
  ) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 200),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(value: buttonStyle == s, onChanged: onChanged),
          Text(txt),
        ],
      ),
    );
  }

  Widget _buildMenuSetting(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildButtonStyleCheckbox(MenuButtonStyle.iconOnly, "iconOnly", (v) {
          setState(() {
            if (v ?? false) {
              buttonStyle = MenuButtonStyle.iconOnly;
            }
          });
        }),
        _buildButtonStyleCheckbox(
          MenuButtonStyle.textFollowIcon,
          "textFollowIcon",
          (v) {
            setState(() {
              if (v ?? false) {
                buttonStyle = MenuButtonStyle.textFollowIcon;
              }
            });
          },
        ),
        _buildButtonStyleCheckbox(MenuButtonStyle.textOnly, "textOnly", (v) {
          setState(() {
            if (v ?? false) {
              buttonStyle = MenuButtonStyle.textOnly;
            }
          });
        }),
        _buildButtonStyleCheckbox(
          MenuButtonStyle.textUnderIcon,
          "textUnderIcon",
          (v) {
            setState(() {
              if (v ?? false) {
                buttonStyle = MenuButtonStyle.textUnderIcon;
              }
            });
          },
        ),
      ],
    );
  }

  Widget _leftMenu(BuildContext context) {
    return RuiToolbar(
      vertical: true,
      buttonStyle: buttonStyle,
      items: [
        RuiMenuItem(id: '1', icon: Icons.home, title: 'Home'),
        RuiMenuItem(id: '3', icon: Icons.movie, title: 'Movie'),
        RuiMenuItem(id: '4', icon: Icons.music_video, title: 'Music'),
        RuiMenuItem(id: '5', icon: Icons.games, title: 'Game'),
        RuiMenuItem(
          id: '2',
          icon: Icons.settings,
          title: 'Settings',
          subItems: [
            RuiMenuItem(id: '2-1', icon: Icons.settings, title: 'Sound'),
            RuiMenuItem(id: '2-2', icon: Icons.settings, title: 'Movie'),
          ],
        ),
        RuiMenuItem(
          id: '2',
          icon: Icons.info,
          title: 'About',
          subItems: [
            RuiMenuItem(
              id: '2-1',
              icon: Icons.location_city,
              title: 'Location',
            ),
            RuiMenuItem(id: '2-2', icon: Icons.telegram, title: 'Telegram'),
          ],
        ),
      ],
    );
  }
}
