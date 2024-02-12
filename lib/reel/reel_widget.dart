import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReelWidget extends StatefulWidget {
  final List<Widget> children;
  final double childSize;
  late final double wholeSize;
  final int oneSpinTime;
  late final ScrollController _scrollController =
      ScrollController(initialScrollOffset: Random().nextDouble() * wholeSize);

  ReelWidget({
    Key? key,
    required this.children,
    required this.childSize,
    this.oneSpinTime = 25,
  }) : super(key: key) {
    wholeSize = childSize * (children.length + 1);
  }

  void runAnimation() async {
    _scrollController.jumpTo(0);
    for (int i = 0; i < Random().nextInt(5) + 3; i++) {
      await _scrollController.animateTo(wholeSize,
          duration: Duration(milliseconds: oneSpinTime * children.length),
          curve: Curves.linear);
      _scrollController.jumpTo(0);
    }
    await _scrollController.animateTo(wholeSize,
        duration: Duration(
          milliseconds: oneSpinTime * children.length * 4,
        ),
        curve: Curves.linear);
    _scrollController.jumpTo(0);

    int num = Random().nextInt(children.length);
    _scrollController.animateTo(
      (num + 0.1) * childSize,
      duration: Duration(
        milliseconds: oneSpinTime * children.length * 4,
      ),
      curve: Curves.decelerate,
    );
  }

  @override
  _ReelWidgetState createState() => _ReelWidgetState();
}

class _ReelWidgetState extends State<ReelWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget._scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      height: widget.childSize * 1.1,
      decoration: const BoxDecoration(),
      child: ListView(
        controller: widget._scrollController,
        physics: const NeverScrollableScrollPhysics(),
        children: widget.children,
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String text;
  const CardWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapInside: (event) async {
        await Clipboard.setData(ClipboardData(text: text)).then((value) =>
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Copied to clipboard"))));
      }, 
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(text)),
        ),
      ),
    );
  }
}
