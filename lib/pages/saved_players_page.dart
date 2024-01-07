import 'dart:convert';

import 'package:dotareviewer/cards/player_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedPlayers extends StatefulWidget {
  const SavedPlayers({super.key});

  @override
  State<SavedPlayers> createState() => _SavedPlayersState();
}

class _SavedPlayersState extends State<SavedPlayers> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences? prefs;
  List<PlayerObject> savedPlayers = [];

  @override
  void initState() {
    super.initState();
    _getPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsetsDirectional.only(top: 20),
        child: ListView.builder(
          itemCount: savedPlayers.length,
          itemBuilder: (context, index) {
            return PlayerCard(
              playerObject: savedPlayers[index],
            );
          },
        ),
      ),
    );
  }

  void _getPlayers() async {
    prefs ??= await _prefs;
    final String? savedText = prefs?.getString('saved_players');
    if (savedText != null) {
      setState(() {
        savedPlayers = (jsonDecode(savedText) as List)
            .map((e) => PlayerObject.fromJson(e as Map<String, dynamic>, true))
            .toList();
      });
    }
  }
}
