// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:dotareviewer/cards/match_card.dart';
import 'package:dotareviewer/cards/player_card.dart';
import 'package:dotareviewer/constants.dart';
import 'package:dotareviewer/globals.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:timezone/timezone.dart' as tz;

class PlayerPage extends StatefulWidget {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences? prefs;
  final PlayerObject playerObject;
  PlayerPage({super.key, required this.playerObject});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  int offset = 0;
  final ScrollController _scrollController = ScrollController();
  List<MatchObject> matches = [];

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    _getMatches();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: _savedPlayer,
              icon: Icon(Icons.star,
                  color: widget.playerObject.isSaved
                      ? Colors.yellowAccent
                      : Colors.grey))
        ],
      ),
      body: Container(
          margin: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  height: 130,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 130,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image(
                            image: NetworkImage(widget.playerObject.avatarfull),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.playerObject.personaname,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  softWrap: true,
                                ),
                                Text(
                                  widget.playerObject.account_id.toString(),
                                  softWrap: true,
                                  textAlign: TextAlign.right,
                                ),
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _getLastMatchTime(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                )),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: DefaultTabController(
                    length: 2,
                    child: Scaffold(
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        title: const TabBar(
                          tabs: [
                            Tab(
                              text: "Matches",
                            ),
                            Tab(
                              text: "Heroes",
                            )
                          ],
                        ),
                      ),
                      body: TabBarView(children: [
                        ListView.builder(
                          controller: _scrollController,
                          itemCount: matches.length,
                          itemBuilder: (context, index) {
                            return MatchCard(
                              matchObject: matches[index],
                              heroObject: heroesData[heroesData.indexWhere(
                                  (x) => x.id == matches[index].hero_id)],
                            );
                          },
                        ),
                        const Icon(Icons.abc),
                      ]),
                    )),
              ),
            ],
          )),
    );
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      offset += 10;
      _getMatches();
    }
  }

  String _getLastMatchTime() {
    String lastMatchTime = widget.playerObject.last_match_time;
    if (lastMatchTime != "") {
      DateTime dateTime =
          DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").parseUTC(lastMatchTime);
      tz.Location defaultTimeZone = tz.local;
      tz.TZDateTime newDateTime = tz.TZDateTime.from(dateTime, defaultTimeZone);
      lastMatchTime =
          "Last match: ${DateFormat("yyyy.MM.dd HH:mm").format(newDateTime)}";
    } else {
      lastMatchTime = "";
    }
    return lastMatchTime;
  }

  void _getMatches() async {
    var url = Uri.http(
        origin,
        "$players/${widget.playerObject.account_id}/matches",
        {"limit": "10", "offset": offset.toString()});
    var response = await http.get(url);
    if (response.body != "[]" && mounted) {
      String jsonText = '{"objects": ${response.body}}';
      Map<String, dynamic> jsonResponse = json.decode(jsonText);
      List<dynamic> objectsData = jsonResponse['objects'];
      setState(() {
        matches.addAll(
            objectsData.map((json) => MatchObject.fromJson(json)).toList());
      });
    }
  }

  void _savedPlayer() async {
    setState(() {
      widget.playerObject.setIsSaved(!widget.playerObject.isSaved);
    });
    widget.prefs ??= await widget._prefs;
    final String? savedText = widget.prefs?.getString('saved_players');
    List<PlayerObject> savedPlayers = [];

    if (savedText != null) {
      savedPlayers = (jsonDecode(savedText) as List)
          .map((e) => PlayerObject.fromJson(e as Map<String, dynamic>, true))
          .toList();
    }

    if (!widget.playerObject.isSaved) {
      savedPlayers
          .removeWhere((x) => x.account_id == widget.playerObject.account_id);
    } else {
      savedPlayers.add(widget.playerObject);
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonList = jsonEncode(savedPlayers);
    prefs.setString('saved_players', jsonList);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
