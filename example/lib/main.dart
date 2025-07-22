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
      title: 'RUI Toolbar Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      home: const MyHomePage(title: 'RUI Toolbar Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool inboxChecked = true;

  MenuButtonStyle buttonStyle = MenuButtonStyle.iconOnly;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Row(
        children: [_leftMenu(context), Expanded(child: _buildBody(context))],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return RuiToolbar(
      buttonStyle: buttonStyle,
      iconSize: 16,
      onToolItemSelect: (item) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected menu item: ${item.id} - ${item.title}'),
            // duration: const Duration(seconds: 2),
          ),
        );
      },
      items: [
        RuiMenuItem(id: 'top-1', icon: Icons.home, title: 'Home'),
        RuiMenuItem(
          id: 'top-2',
          icon: Icons.settings,
          title: 'All Settings',
          subItems: [
            RuiMenuItem(
              id: 'top-2-1',
              icon: Icons.settings,
              title: 'Sound of Setting',
              subItems: [
                RuiMenuItem(
                  id: 'top-2-1-1',
                  icon: Icons.settings,
                  title: 'Sound-1',
                ),
                RuiMenuItem(
                  id: 'top-2-1-2',
                  icon: Icons.settings,
                  title: 'Sound-2',
                ),
                RuiMenuItem(
                  id: 'top-2-1-3',
                  icon: Icons.settings,
                  title: 'Sound-3',
                ),
                RuiMenuItem(
                  id: 'top-2-1-4',
                  icon: Icons.settings,
                  title: 'Sound-4',
                ),
              ],
            ),
            RuiMenuItem(id: 'top-2-2', icon: Icons.settings, title: 'Movie'),
            RuiMenuItem(
              id: 'top-2-3',
              icon: Icons.inbox,
              checked: inboxChecked,
              title: 'Inbox',
              onPressed: (RuiMenuItem item) {
                print("onPressed item $item");
                setState(() {
                  // item.checked != item.checked;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[_buildTopBar(context), _buildMenuSetting(context)],
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
        RuiMenuItem(id: 'left-1', icon: Icons.home, title: 'Home'),
        RuiMenuItem(id: 'left-3', icon: Icons.movie, title: 'Movie'),
        RuiMenuItem(id: 'left-4', icon: Icons.music_video, title: 'Music'),
        RuiMenuItem(id: 'left-5', icon: Icons.games, title: 'Game'),
        RuiMenuItem(
          id: 'left-2',
          icon: Icons.settings,
          title: 'All Media Settings',
          subItems: [
            RuiMenuItem(
              id: 'left-2-1',
              icon: Icons.settings,
              title: 'Sound',
              subItems: [
                RuiMenuItem(
                  id: 'left-2-1-1',
                  icon: Icons.voice_chat,
                  title: 'Tone',
                ),
                RuiMenuItem(
                  id: 'left-2-1-2',
                  icon: Icons.volume_down,
                  title: 'Volume',
                ),
              ],
            ),
            RuiMenuItem(id: 'left-2-2', icon: Icons.settings, title: 'Movie'),
          ],
        ),
        RuiMenuItem(
          id: 'left-6',
          icon: Icons.info,
          title: 'About',
          subItems: [
            RuiMenuItem(
              id: 'left-6-1',
              icon: Icons.location_city,
              title: 'Location',
            ),
            RuiMenuItem(
              id: 'left-6-2',
              icon: Icons.telegram,
              title: 'Telegram',
            ),
          ],
        ),
      ],
    );
  }
}
