import 'package:flutter/material.dart';
import 'package:wtdapp/utils/drawer_widget.dart';
import 'package:wtdapp/reel/reel_widget.dart';
import 'package:wtdapp/utils/storage_service.dart';

class ReelPage extends StatefulWidget {
  const ReelPage({super.key});
  final String title = "";

  @override
  State<ReelPage> createState() => _ReelPageState();
}

class _ReelPageState extends State<ReelPage> {
  late List<Widget> children;
  late ReelWidget reel;
  List<String> _currentList = [];
  List<String> _allListNames = [];
  String _currentListName = "";
  final Helper helper = Helper();

  @override
  void initState() {
    super.initState();
    _prepare();
    _loadList();
    _reinit(_currentList);
    helper.addListener(() async {
      await _update();
    });
  }

  Future _update() async {
    _currentListName = await helper.getCurrentListName();
    var currentList = await helper.getSpecificList(_currentListName);
    _reinit(currentList);
  }

  void _prepare() async {
    _allListNames = await helper.getAllListsNames();
    _currentListName = await helper.getCurrentListName();
    return Future(() => true);
  }

  void _loadList({String name = ""}) async {
    if (name.isEmpty) {
      name = await helper.getCurrentListName();
    }
    _currentListName = name;
    var currentList = await helper.getSpecificList(name);
    if (currentList.isEmpty) return;
    _reinit(currentList);
    return;
  }

  void _reinit(currentList) {
    _currentList = currentList;
    children = [for (var t in _currentList) CardWidget(text: t)];
    reel = ReelWidget(
      childSize: 40,
      children: children,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: const Text(
                "Roll the Drum!",
              ),
              onPressed: () {
                reel.runAnimation();
              },
            ),
          ],
        ),
      ),
    );
  }
}
