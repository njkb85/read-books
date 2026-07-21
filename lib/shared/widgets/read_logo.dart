import 'package:flutter/material.dart';

class ReadLogo extends StatelessWidget {
  final double size;
  
  const ReadLogo({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(size * 0.1),
        border: Border.all(color: Colors.white, width: size * 0.025),
      ),
      child: Center(
        child: Text(
          'R',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.55,
            fontWeight: FontWeight.w900,
            fontFamily: 'serif',
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
