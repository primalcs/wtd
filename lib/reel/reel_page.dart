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
  String _currentListName = "";

  @override
  void initState() {
    super.initState();
    _prepare();
    _loadList();
  }

  void _prepare() async {
    // var key = await Helper.getCurrentListName();
    Helper.setSpecificList("cobold", ["nol", "celkoviy"]);
    Helper.setSpecificList("default", ["Do nothing"]);
    Helper.setAllListsNames(["default", "cobold"]);
    await Helper.setCurrentListName("cobold");
  }

  void _loadList({String name = ""}) async {
    if (name.isEmpty) {
      name = await Helper.getCurrentListName();
    }
    _currentListName = name;
    var currentList = await Helper.getSpecificList(name);
    if (currentList.isEmpty) return;
    setState(() {
      _reinit(currentList);
    });
  }

  void _reinit(currentList) {
    _currentList = currentList;
    children = [for (var t in _currentList) CardWidget(text: t)];
    reel = ReelWidget(
      childSize: 40,
      children: children,
    );
  }

  Widget createHeader() {
    return ExpandingListView(mode: false, currentText: _currentListName);
  }

  @override
  Widget build(BuildContext context) {
    _reinit(_currentList);
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
              // controller: iconController,
              requestFocusOnTap: true,
              label: const Text('Activities'),
              inputDecorationTheme: const InputDecorationTheme(
                // filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: 5.0),
              ),
              onSelected: (icon) {
                setState(() {
                  // selectedIcon = icon;
                });
              },
              dropdownMenuEntries: [
                DropdownMenuEntry(value: "value", label: "label")
              ],
            ),
            reel,
            TextButton(
              child: const Text(
                "Roll the Drum!",
              ),
              onPressed: () => reel.runAnimation(),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpandingListView extends StatefulWidget {
  final bool mode;
  final String currentText;
  const ExpandingListView(
      {Key? key, required this.mode, required this.currentText})
      : super(key: key);

  @override
  _ExpandingListViewState createState() => _ExpandingListViewState();
}

class _ExpandingListViewState extends State<ExpandingListView> {
  @override
  Widget build(BuildContext context) {
    if (!widget.mode) {
      return Flexible(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.currentText),
          ),
        ),
      );
    }
    return Container();
  }
}
