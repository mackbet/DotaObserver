// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:dotareviewer/cards/match_card.dart';
import 'package:dotareviewer/cards/player_card.dart';
import 'package:dotareviewer/constants.dart';
import 'package:dotareviewer/globals.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SearchPlayer extends StatefulWidget {
  const SearchPlayer({super.key});

  @override
  State<SearchPlayer> createState() => _SearchPlayerState();
}

class _SearchPlayerState extends State<SearchPlayer> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences? prefs;
  List<PlayerObject> savedPlayers = [];
  String lastText = "";
  List<PlayerObject> items = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Search players by personaname',
            ),
            onChanged: searchPlayer,
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsetsDirectional.only(top: 20),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return PlayerCard(
                    playerObject: items[index],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void searchPlayer(String text) async {
    lastText = text;
    var url = Uri.http(origin, search, {'q': text});
    var response = await http.get(url);
    if (response.body != "[]") {
      String jsonText = '{"objects":' + response.body + "}";
      Map<String, dynamic> jsonResponse = json.decode(jsonText);
      List<dynamic> objectsData = jsonResponse['objects'];
      if (text == lastText) {
        setState(() {
          items = objectsData
              .map((json) => PlayerObject.fromJson(json, false))
              .toList();

          for (var player in items) {
            player.setIsSaved(savedPlayers.indexWhere((savedPlayer) =>
                    savedPlayer.account_id == player.account_id) !=
                -1);
          }
        });
      } else {
        setState(() {
          items = [];
        });
      }
    }
  }

  void _fetchData() async {
    var url = Uri.http(origin, heroes);
    var response = await http.get(url);
    if (response.body != "[]" && mounted) {
      String jsonText = '{"objects": ${response.body}}';
      Map<String, dynamic> jsonResponse = json.decode(jsonText);
      List<dynamic> objectsData = jsonResponse['objects'];
      setState(() {
        heroesData =
            (objectsData.map((json) => HeroObject.fromJson(json)).toList());
      });
    }
    prefs ??= await _prefs;
    final String? savedText = prefs?.getString('saved_players');
    if (savedText != null && mounted) {
      setState(() {
        savedPlayers = (jsonDecode(savedText) as List)
            .map((e) => PlayerObject.fromJson(e as Map<String, dynamic>, true))
            .toList();
      });
    }
  }
}
