// import 'dart:math';
// import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardWidget extends StatelessWidget {
  final String text;
  final double implicitSize;
  const CardWidget({super.key, required this.text, required this.implicitSize});

  @override
  Widget build(BuildContext context) {
    // var c = Card(
    //   margin: const EdgeInsets.all(0.0),
    //   child: Center(
    //     child: Text(
    //       text,
    //       // style: TextStyle(fontSize: implicitSize),
    //     ),
    //   ),
    // );
    var c = SizedBox(
      height: implicitSize,
      child: Center(
        child: AutoSizeText(
          text,
          minFontSize: implicitSize / 2,
        ),
      ),
    );
    return TapRegion(
      onTapInside: (event) async {
        await Clipboard.setData(ClipboardData(text: text)).then((value) =>
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Copied to clipboard"))));
      },
      child: c,
    );
  }
}
