import 'package:dotareviewer/pages/saved_players_page.dart';
import 'package:dotareviewer/pages/search__player.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  tz.initializeTimeZones();

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Dota Reviewer'),
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
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.search),
              ),
              Tab(
                icon: Icon(Icons.star),
              ),
              /*Tab(
                icon: Icon(Icons.person),
              )*/
            ],
          ),
        ),
        body: const TabBarView(children: [
          SearchPlayer(),
          SavedPlayers(),
          //Heroes(),
        ]),
      ),
    );
  }
}
