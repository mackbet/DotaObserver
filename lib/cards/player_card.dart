// ignore_for_file: non_constant_identifier_names, prefer_const_constructors_in_immutables

import 'package:dotareviewer/pages/player_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class PlayerCard extends StatelessWidget {
  final PlayerObject playerObject;

  PlayerCard({super.key, required this.playerObject});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlayerPage(playerObject: playerObject)),
          );
        },
        child: SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image(
                    image: NetworkImage(playerObject.avatarfull),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 10, vertical: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        playerObject.personaname,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _getLastMatchTime(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getLastMatchTime() {
    String lastMatchTime = playerObject.last_match_time;
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
}

class PlayerObject {
  final int account_id;
  final String avatarfull;
  final String personaname;
  final double similarity;
  final String last_match_time;
  bool isSaved;

  PlayerObject(
      {required this.account_id,
      required this.avatarfull,
      required this.personaname,
      required this.similarity,
      required this.last_match_time,
      required this.isSaved});

  factory PlayerObject.fromJson(Map<String, dynamic> json, bool isSaved) {
    return PlayerObject(
      account_id: json['account_id'],
      avatarfull: json['avatarfull'],
      personaname: json['personaname'],
      similarity: json['similarity'],
      last_match_time: json['last_match_time'] ?? "",
      isSaved: isSaved,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'account_id': account_id,
      'avatarfull': avatarfull,
      'personaname': personaname,
      'similarity': similarity,
      'last_match_time': last_match_time,
      'isSaved': isSaved,
    };
  }

  void setIsSaved(bool state) {
    isSaved = state;
  }
}
