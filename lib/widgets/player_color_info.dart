import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayerColorInfo extends StatelessWidget {
  const PlayerColorInfo(
      {Key? key, required this.playerName, required this.color})
      : super(key: key);

  final String playerName;
  final color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 72, 80, 74),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 160,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                playerName,
                style: GoogleFonts.josefinSans(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              Container(height: 30, width: 30, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
