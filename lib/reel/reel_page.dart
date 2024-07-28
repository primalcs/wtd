import 'package:flutter/material.dart';
import 'package:wtdapp/utils/drawer_widget.dart';
import 'package:wtdapp/reel/reel_widget.dart';
import 'package:wtdapp/reel/card.dart';
import 'package:wtdapp/utils/storage_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReelPage extends StatefulWidget {
  const ReelPage({super.key, required this.storage});
  final String title = "";
  final Helper storage;

  @override
  State<ReelPage> createState() => _ReelPageState();
}

class _ReelPageState extends State<ReelPage> {
  late List<Widget> children;
  late ReelWidget reel;
  List<String> _currentList = [];
  List<String> _allListNames = [];
  String _currentListName = "";

  @override
  void initState() {
    super.initState();
    _prepare();
    _loadList();
    _reinit(_currentList);
    widget.storage.addListener(() async {
      await _update();
    });
  }

  Future _update() async {
    _currentListName = await widget.storage.getCurrentListName();
    var currentList = await widget.storage.getSpecificList(_currentListName);
    _reinit(currentList);
  }

  void _prepare() async {
    _allListNames = await widget.storage.getAllListsNames();
    _currentListName = await widget.storage.getCurrentListName();
    return Future(() => true);
  }

  void _loadList({String name = ""}) async {
    if (name.isEmpty) {
      name = await widget.storage.getCurrentListName();
    }
    _currentListName = name;
    var currentList = await widget.storage.getSpecificList(name);
    if (currentList.isEmpty) return;
    _reinit(currentList);
    return;
  }

  void _reinit(currentList) {
    _currentList = currentList;
    const childSize = 130.0;
    children = [
      for (var t in _currentList)
        CardWidget(
          text: t,
          implicitSize: childSize,
        )
    ];
    children.addAll([
      for (var t in _currentList)
        CardWidget(
          text: t,
          implicitSize: childSize,
        )
    ]);

    reel = ReelWidget(
      childSize: childSize,
      children: children,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.storage.initialColorMode
          ? ThemeData.dark()
          : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        drawer: const DrawerWidget(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DropdownMenu(
                requestFocusOnTap: true,
                label: const Text('Activities'),
                inputDecorationTheme: const InputDecorationTheme(
                  contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                ),
                initialSelection: _currentListName,
                onSelected: (value) {
                  setState(() {
                    _loadList(name: value.toString());
                  });
                },
                dropdownMenuEntries: [
                  for (String i in _allListNames)
                    DropdownMenuEntry(value: i, label: i)
                ],
              ),
              reel,
              TextButton(
                child: Text(
                  AppLocalizations.of(context)!.rollTheDrum,
                ),
                onPressed: () {
                  reel.runAnimation();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
