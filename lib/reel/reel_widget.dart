import 'dart:math';
// import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

class ReelWidget extends StatefulWidget {
  final List<Widget> children;
  final double childSize;
  late final double wholeSize;
  final int oneSpinTime;
  late final ScrollController _scrollController =
      ScrollController(initialScrollOffset: _random.nextDouble() * wholeSize);
  final _random = Random.secure();

  ReelWidget({
    super.key,
    required this.children,
    required this.childSize,
    this.oneSpinTime = 25,
  }) {
    wholeSize = childSize * (children.length + 1);
  }

  void runAnimation() async {
    if (children.length <= 1) return;
    _scrollController.jumpTo(0);
    for (int i = 0; i < Random().nextInt(6) + 4; i++) {
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

    int num = _random.nextInt(children.length ~/ 2);
    num += children.length ~/ 4;
    _scrollController.animateTo(
      num * (childSize),
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
      height: widget.childSize * 1.0,
      decoration: const BoxDecoration(),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: ListView(
          controller: widget._scrollController,
          physics: const NeverScrollableScrollPhysics(),
          children: widget.children,
        ),
      ),
    );
  }
}
