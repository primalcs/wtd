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
  var _currentList = [];

  @override
  void initState() {
    super.initState();
    // _prepare();
    _loadList();
  }

  void _prepare() async {
    var key = await Helper.getCurrentListName();
    await Helper.setSpecificList(key, ["lol", "nuleviy"]);
  }

  void _loadList() async {
    var key = await Helper.getCurrentListName();
    var currentList = await Helper.getSpecificList(key);
    if (currentList.isEmpty) return;
    setState(() {
      reinit(currentList);
    });
  }

  void reinit(currentList) {
    _currentList = currentList;
    children = [for (var t in _currentList) CardWidget(text: t)];
    reel = ReelWidget(
      childSize: 40,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    reinit(_currentList);
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
