// ignore_for_file: non_constant_identifier_names, prefer_const_constructors_in_immutables, must_be_immutable
import 'package:dotareviewer/globals.dart';
import 'package:flutter/material.dart';

class MatchCard extends StatelessWidget {
  final MatchObject matchObject;
  final HeroObject heroObject;

  MatchCard({super.key, required this.matchObject, required this.heroObject});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () => {},
        child: SizedBox(
            height: 60,
            child: Container(
              margin: const EdgeInsets.all(8),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image(
                      image: NetworkImage(
                          Utilities.getHeroImageURL(heroObject.name)),
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return const Icon(Icons.error);
                      },
                    ),
                  ),
                  Expanded(
                      child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _getWonLost(),
                        Text(
                          _getDuration(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          _getScore(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
                  ))
                ],
              ),
            )),
      ),
    );
  }

  Text _getWonLost() {
    String text;
    Color color;
    if (matchObject.player_slot <= 127) {
      if (matchObject.radiant_win) {
        text = "Won";
        color = Colors.greenAccent;
      } else {
        text = "Lost";
        color = Colors.redAccent;
      }
    } else {
      if (matchObject.radiant_win) {
        text = "Lost";
        color = Colors.redAccent;
      } else {
        text = "Won";
        color = Colors.greenAccent;
      }
    }
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w900,
        fontSize: 18,
      ),
    );
  }

  String _getScore() {
    String text =
        "${matchObject.kills}/${matchObject.deaths}/${matchObject.assists}";
    return text;
  }

  String _getDuration() {
    String text = "";
    Duration duration = Duration(seconds: matchObject.duration);
    if (duration.inHours > 0) text += "${duration.inHours}:";
    if (duration.inMinutes > 0) {
      text += "${duration.inMinutes % 60}:";
    }
    if (duration.inSeconds > 0) {
      text += (duration.inSeconds % 60).toString().padLeft(2, '0');
    }
    return text;
  }
}

class MatchObject {
  final int match_id;
  final int player_slot;
  final bool radiant_win;
  final int duration;
  final int game_mode;
  final int lobby_type;
  final int hero_id;
  final int start_time;
  final int? version;
  final int kills;
  final int deaths;
  final int assists;
  final int? skill;
  final int? average_rank;
  final int leaver_status;
  final int? party_size;

  MatchObject({
    required this.match_id,
    required this.player_slot,
    required this.radiant_win,
    required this.duration,
    required this.game_mode,
    required this.lobby_type,
    required this.hero_id,
    required this.start_time,
    required this.version,
    required this.kills,
    required this.deaths,
    required this.assists,
    required this.skill,
    required this.average_rank,
    required this.leaver_status,
    required this.party_size,
  });

  factory MatchObject.fromJson(Map<String, dynamic> json) {
    return MatchObject(
      match_id: json['match_id'],
      player_slot: json['player_slot'],
      radiant_win: json['radiant_win'],
      duration: json['duration'],
      game_mode: json['game_mode'],
      lobby_type: json['lobby_type'],
      hero_id: json['hero_id'],
      start_time: json['start_time'],
      version: json['version'],
      kills: json['kills'],
      deaths: json['deaths'],
      assists: json['assists'],
      skill: json['skill'],
      average_rank: json['average_rank'],
      leaver_status: json['leaver_status'],
      party_size: json['party_size'],
    );
  }
}

class HeroObject {
  final int id;
  final String name;
  final String primary_attr;
  final String attack_type;

  HeroObject(
      {required this.id,
      required this.name,
      required this.primary_attr,
      required this.attack_type});

  factory HeroObject.fromJson(Map<String, dynamic> json) {
    return HeroObject(
      id: json['id'],
      name: json['localized_name'],
      primary_attr: json['primary_attr'],
      attack_type: json['attack_type'],
    );
  }
}
