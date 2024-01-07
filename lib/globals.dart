import 'package:dotareviewer/cards/match_card.dart';

List<HeroObject> heroesData = [];

class Utilities {
  static String getHeroImageURL(String name) {
    name = name.toLowerCase().replaceAll(" ", "_");
    switch (name) {
      case "doom":
        name = "doom_bringer";
        break;
      case "windranger":
        name = "windrunner";
      case "necrophos":
        name = "necrolyte";
        break;
      case "timbersaw":
        name = "shredder";
        break;
      case "clockwerk":
        name = "rattletrap";
        break;
      case "shadow_fiend":
        name = "nevermore";
        break;
      case "outworld_destroyer":
        name = "obsidian_destroyer";
        break;
      case "lifestealer":
        name = "life_stealer";
        break;
      case "centaur_warrunner":
        name = "centaur";
        break;
      case "vengeful_spirit":
        name = "vengefulspirit";
        break;
      case "wraith_king":
        name = "skeleton_king";
        break;
      case "zeus":
        name = "zuus";
        break;
      case "anti-mage":
        name = "antimage";
        break;
      case "magnus":
        name = "magnataur";
        break;
      case "treant_protector":
        name = "treant";
        break;
      case "queen_of_pain":
        name = "queenofpain";
        break;
      case "nature's_prophet":
        name = "furion";
        break;
      case "io":
        name = "wisp";
      case "underlord":
        name = "abyssal_underlord";
        break;
      default:
        break;
    }
    return "https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/$name.png";
    //return "https://cdn.dota2.com/apps/dota2/images/heroes/${name}_full.png";
  }
}
