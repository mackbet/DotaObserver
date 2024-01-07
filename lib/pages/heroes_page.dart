import 'package:dotareviewer/globals.dart';
import 'package:flutter/material.dart';

class Heroes extends StatelessWidget {
  const Heroes({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: heroesData.length,
      itemBuilder: (context, index) {
        return SizedBox(
          height: 50,
          child: Image(
            image: NetworkImage(
              Utilities.getHeroImageURL(heroesData[index].name.toString()),
            ),
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) {
              return const Icon(
                  Icons.error); // Установите путь к вашей стандартной картинке
            },
          ),
        );
      },
    );
  }
}
